const API_BASE = "http://35.154.150.60/api"; // Replace with your EC2 public IP or domain

async function getStatus() {
  try {
    const res = await fetch(`${API_BASE}/status`);
    const data = await res.json();
    document.getElementById("statusOutput").textContent = JSON.stringify(data, null, 2);
  } catch (err) {
    document.getElementById("statusOutput").textContent = "Error: " + err.message;
  }
}

async function getInstanceDetails() {
  try {
    const res = await fetch(`${API_BASE}/instance-details`);
    const data = await res.json();
    document.getElementById("instanceOutput").textContent = JSON.stringify(data, null, 2);
  } catch (err) {
    document.getElementById("instanceOutput").textContent = "Error: " + err.message;
  }
}

async function getS3Objects() {
  try {
    const res = await fetch(`${API_BASE}/s3-objects`);
    const data = await res.json();
    document.getElementById("s3Output").textContent = JSON.stringify(data, null, 2);
  } catch (err) {
    document.getElementById("s3Output").textContent = "Error: " + err.message;
  }
}
