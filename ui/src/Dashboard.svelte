<script>
  import { onMount, onDestroy } from 'svelte';
  import { getStatus, getHealth } from './api.js';

  let status = null;
  let health = null;
  let loading = true;
  let error = null;
  let interval;

  onMount(() => {
    loadData();
    interval = setInterval(loadData, 5000); // Refresh every 5 seconds
  });

  onDestroy(() => {
    if (interval) clearInterval(interval);
  });

  async function loadData() {
    try {
      const [statusData, healthData] = await Promise.all([
        getStatus(),
        getHealth()
      ]);
      status = statusData;
      health = healthData;
      error = null;
    } catch (err) {
      error = `Failed to load metrics: ${err.message}`;
    } finally {
      loading = false;
    }
  }

  function getStatusClass(metric) {
    if (!metric) return '';
    if (metric.value >= metric.threshold * 0.9) return 'status-critical';
    if (metric.value >= metric.threshold * 0.75) return 'status-warning';
    return 'status-ok';
  }

  function getStatusIcon(metric) {
    if (!metric) return '●';
    if (metric.value >= metric.threshold * 0.9) return '⚠';
    if (metric.value >= metric.threshold * 0.75) return '◐';
    return '✓';
  }

  function formatUptime(seconds) {
    if (!seconds) return '0s';
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = Math.floor(seconds % 60);
    
    if (hours > 0) return `${hours}h ${minutes}m`;
    if (minutes > 0) return `${minutes}m ${secs}s`;
    return `${secs}s`;
  }
</script>

<div class="dashboard">
  {#if loading && !status}
    <div class="card">
      <div class="loading">
        <div class="spinner"></div>
        <p>Loading metrics...</p>
      </div>
    </div>
  {:else if error}
    <div class="card">
      <div class="error-message">
        ⚠️ {error}
        <button on:click={loadData}>Retry</button>
      </div>
    </div>
  {:else}
    <!-- System Status -->
    <div class="card status-overview">
      <div class="status-header">
        <h2> System Status</h2>
        <div class="status-badge {status.ok ? 'status-ok' : 'status-critical'}">
          {status.ok ? '✓ Healthy' : '⚠ Alert'}
        </div>
      </div>
      
      {#if health}
        <div class="health-info">
          <div class="health-item">
            <span class="label">Uptime:</span>
            <span class="value">{formatUptime(health.uptime_seconds)}</span>
          </div>
          <div class="health-item">
            <span class="label">Glances:</span>
            <span class="value {health.glances_connected ? 'status-ok' : 'status-critical'}">
              {health.glances_connected ? '✓ Connected' : '✗ Disconnected'}
            </span>
          </div>
        </div>
      {/if}
    </div>

    <!-- Metrics Grid -->
    <div class="metrics-grid">
      <!-- RAM -->
      {#if status.ram}
        <div class="card metric-card">
          <div class="metric-header">
            <h3>💾 RAM Usage</h3>
            <span class="metric-icon {getStatusClass(status.ram)}">
              {getStatusIcon(status.ram)}
            </span>
          </div>
          <div class="metric-value {getStatusClass(status.ram)}">
            {status.ram.value.toFixed(1)}%
          </div>
          <div class="metric-bar">
            <div 
              class="metric-bar-fill {getStatusClass(status.ram)}"
              style="width: {status.ram.value}%"
            ></div>
          </div>
          <div class="metric-threshold">
            Threshold: {status.ram.threshold}%
          </div>
        </div>
      {/if}

      <!-- CPU -->
      {#if status.cpu}
        <div class="card metric-card">
          <div class="metric-header">
            <h3>⚡ CPU Usage</h3>
            <span class="metric-icon {getStatusClass(status.cpu)}">
              {getStatusIcon(status.cpu)}
            </span>
          </div>
          <div class="metric-value {getStatusClass(status.cpu)}">
            {status.cpu.value.toFixed(1)}%
          </div>
          <div class="metric-bar">
            <div 
              class="metric-bar-fill {getStatusClass(status.cpu)}"
              style="width: {status.cpu.value}%"
            ></div>
          </div>
          <div class="metric-threshold">
            Threshold: {status.cpu.threshold}%
          </div>
        </div>
      {/if}

      <!-- Disk -->
      {#if status.disk}
        <div class="card metric-card disk-card">
          <div class="metric-header">
            <h3>💿 Disk Usage</h3>
            <span class="metric-icon {status.disk.ok ? 'status-ok' : 'status-critical'}">
              {status.disk.ok ? '✓' : '⚠'}
            </span>
          </div>
          
          {#if status.disk.disks && status.disk.disks.length > 0}
            {#each status.disk.disks as disk}
              <div class="disk-item">
                <div class="disk-header">
                  <span class="disk-mount">{disk.mount}</span>
                  <span class="disk-value {disk.value >= disk.threshold * 0.9 ? 'status-critical' : disk.value >= disk.threshold * 0.75 ? 'status-warning' : 'status-ok'}">
                    {disk.value.toFixed(1)}%
                  </span>
                </div>
                <div class="metric-bar">
                  <div 
                    class="metric-bar-fill {disk.value >= disk.threshold * 0.9 ? 'status-critical' : disk.value >= disk.threshold * 0.75 ? 'status-warning' : 'status-ok'}"
                    style="width: {disk.value}%"
                  ></div>
                </div>
              </div>
            {/each}
          {:else}
            <div class="no-data">No disk data available</div>
          {/if}
          
          <div class="metric-threshold">
            Threshold: {status.disk.threshold}%
          </div>
        </div>
      {/if}
    </div>

    <div class="last-update">
      Last updated: {new Date(status.last_check).toLocaleTimeString()}
      <span class="pulse">●</span>
    </div>
  {/if}
</div>

<style>
  .dashboard {
    margin-bottom: 2rem;
  }

  h2 {
    font-size: 1.75rem;
    color: var(--text-primary);
  }

  h3 {
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--text-primary);
  }

  .loading {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 3rem;
    gap: 1rem;
  }

  .spinner {
    width: 48px;
    height: 48px;
    border: 4px solid var(--bg-card);
    border-top-color: var(--accent-blue);
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }

  .error-message {
    background: rgba(239, 68, 68, 0.1);
    border: 1px solid var(--accent-red);
    color: var(--accent-red);
    padding: 1rem;
    border-radius: 8px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .status-overview {
    margin-bottom: 1.5rem;
  }

  .status-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
  }

  .status-badge {
    padding: 0.5rem 1rem;
    border-radius: 20px;
    font-weight: 600;
    font-size: 0.9rem;
  }

  .health-info {
    display: flex;
    gap: 2rem;
    padding-top: 1rem;
    border-top: 1px solid var(--border);
  }

  .health-item {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  .health-item .label {
    color: var(--text-secondary);
    font-size: 0.85rem;
  }

  .health-item .value {
    font-size: 1.1rem;
    font-weight: 600;
  }

  .metrics-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1.5rem;
    margin-bottom: 1.5rem;
  }

  .metric-card {
    position: relative;
  }

  .metric-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
  }

  .metric-icon {
    font-size: 1.5rem;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: var(--bg-card);
  }

  .metric-value {
    font-size: 3rem;
    font-weight: 700;
    margin-bottom: 1rem;
    line-height: 1;
  }

  .metric-bar {
    height: 12px;
    background: var(--bg-card);
    border-radius: 6px;
    overflow: hidden;
    margin-bottom: 0.5rem;
  }

  .metric-bar-fill {
    height: 100%;
    border-radius: 6px;
    transition: width 0.5s ease, background-color 0.3s ease;
  }

  .metric-bar-fill.status-ok {
    background: linear-gradient(90deg, var(--accent-green), #14b8a6);
  }

  .metric-bar-fill.status-warning {
    background: linear-gradient(90deg, var(--accent-yellow), #fb923c);
  }

  .metric-bar-fill.status-critical {
    background: linear-gradient(90deg, var(--accent-red), #f97316);
  }

  .metric-threshold {
    color: var(--text-secondary);
    font-size: 0.85rem;
  }

  .disk-card {
    grid-column: 1 / -1;
  }

  .disk-item {
    margin-bottom: 1rem;
  }

  .disk-item:last-of-type {
    margin-bottom: 1.5rem;
  }

  .disk-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.5rem;
  }

  .disk-mount {
    font-weight: 600;
    color: var(--text-primary);
  }

  .disk-value {
    font-size: 1.25rem;
    font-weight: 700;
  }

  .no-data {
    color: var(--text-secondary);
    text-align: center;
    padding: 2rem;
    font-style: italic;
  }

  .last-update {
    text-align: center;
    color: var(--text-secondary);
    font-size: 0.85rem;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
  }

  .last-update .pulse {
    color: var(--accent-green);
  }
</style>
