const API_BASE = window.location.origin;

export async function getStatus() {
  const response = await fetch(`${API_BASE}/status`);
  if (!response.ok) throw new Error('Failed to fetch status');
  return response.json();
}

export async function getConfig() {
  const response = await fetch(`${API_BASE}/config`);
  if (!response.ok) throw new Error('Failed to fetch config');
  return response.json();
}

export async function updateConfig(thresholds) {
  const response = await fetch(`${API_BASE}/config`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ thresholds }),
  });
  if (!response.ok) throw new Error('Failed to update config');
  return response.json();
}

export async function getHealth() {
  const response = await fetch(`${API_BASE}/health`);
  if (!response.ok) throw new Error('Failed to fetch health');
  return response.json();
}
