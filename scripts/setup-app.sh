#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting API server setup for Ubuntu..."

apt-get update -y
apt-get install -y nginx curl

# --- 1. Configure Nginx as a Reverse Proxy ---
echo "Configuring Nginx..."
cat <<'EOF' > /etc/nginx/sites-available/api-proxy
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3000; # Forward to Node app
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF
ln -s /etc/nginx/sites-available/api-proxy /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
systemctl enable nginx
echo "Nginx configured."

# --- 2. Install Node.js, PM2, and API Application ---
echo "Installing Node.js and API application..."
sudo -u ubuntu -i <<'EOF'
# Install nvm and Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="/home/ubuntu/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

# Install project dependencies
mkdir /home/ubuntu/app
cd /home/ubuntu/app
npm install express cors aws-sdk 
npm install pm2@latest -g

# Create the Node.js Express application with our APIs
cat <<'EOT' > index.js
const express = require('express');
const cors = require('cors');
const AWS = require('aws-sdk');
const os = require('os');

const app = express();
const port = 3000;

// === IMPORTANT: Enable CORS ===
// This allows your S3 website to make requests to this API server.
app.use(cors());

// --- API Endpoints ---

// 1. Simple status check
app.get('/api/status', (req, res) => {
  res.json({
    status: 'ok',
    serverTime: new Date().toISOString(),
    uptimeSeconds: Math.floor(process.uptime()),
  });
});

// 2. API to get EC2 instance metadata
app.get('/api/instance-details', async (req, res) => {
  try {
    // The aws-sdk will automatically use the IAM role credentials
    const metadata = new AWS.MetadataService();
    const instanceId = await new Promise((res, rej) => {
      metadata.request("/latest/meta-data/instance-id", (err, data) => {
        if (err) rej(err);
        else res(data);
      });
    });
    const region = await new Promise((res, rej) => {
        metadata.request("/latest/meta-data/placement/region", (err, data) => {
            if(err) rej(err);
            else res(data);
        });
    });

    res.json({ instanceId, region, nodeVersion: process.version });
  } catch (error) {
    res.status(500).json({ error: 'Could not fetch instance metadata.' });
  }
});


// 3. API to list objects in the S3 bucket
app.get('/api/s3-objects', async (req, res) => {
  const bucketName = process.env.S3_BUCKET_NAME;

  if (!bucketName) {
    return res.status(500).json({ error: 'S3_BUCKET_NAME environment variable not set on the server.' });
  }

  // AWS SDK uses the attached IAM Role automatically
  const s3 = new AWS.S3();
  const params = { Bucket: bucketName };

  try {
    const data = await s3.listObjectsV2(params).promise();
    const objects = data.Contents.map(item => ({ key: item.Key, size: item.Size, lastModified: item.LastModified }));
    res.json({ bucket: bucketName, objectCount: data.KeyCount, objects });
  } catch (error) {
    console.error("S3 Error:", error);
    res.status(500).json({ error: 'Failed to list S3 objects.', message: error.message });
  }
});

app.listen(port, () => {
  console.log(`API server listening at http://localhost:${port}`);
});
EOT

# Start the app with PM2, passing the bucket name as an environment variable
S3_BUCKET_NAME="ec2-test-bucket-13-08-2025" pm2 start index.js --name "api-server"

# Configure PM2 to restart on boot
env PATH=$PATH:/home/ubuntu/.nvm/versions/node/$(nvm version)/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
EOF
echo "API server setup complete."