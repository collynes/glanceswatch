<script>
  import { onMount } from 'svelte';
  import { getConfig, updateConfig } from './api.js';
  import Slider from './Slider.svelte';

  let thresholds = {
    ram_percent: 80,
    cpu_percent: 80,
    disk_percent: 85
  };
  let originalThresholds = {};
  let loading = true;
  let saving = false;
  let error = null;
  let successMessage = '';
  let hasChanges = false;

  onMount(async () => {
    await loadConfig();
  });

  async function loadConfig() {
    try {
      loading = true;
      error = null;
      const config = await getConfig();
      thresholds = { ...config.thresholds };
      originalThresholds = { ...config.thresholds };
      hasChanges = false;
    } catch (err) {
      error = `Failed to load configuration: ${err.message}`;
    } finally {
      loading = false;
    }
  }

  function checkChanges() {
    hasChanges = 
      thresholds.ram_percent !== originalThresholds.ram_percent ||
      thresholds.cpu_percent !== originalThresholds.cpu_percent ||
      thresholds.disk_percent !== originalThresholds.disk_percent;
  }

  function handleRamChange(value) {
    thresholds.ram_percent = value;
    checkChanges();
  }

  function handleCpuChange(value) {
    thresholds.cpu_percent = value;
    checkChanges();
  }

  function handleDiskChange(value) {
    thresholds.disk_percent = value;
    checkChanges();
  }

  async function saveConfig() {
    try {
      saving = true;
      error = null;
      successMessage = '';
      
      await updateConfig(thresholds);
      originalThresholds = { ...thresholds };
      hasChanges = false;
      successMessage = 'Configuration saved successfully!';
      
      setTimeout(() => {
        successMessage = '';
      }, 3000);
    } catch (err) {
      error = `Failed to save configuration: ${err.message}`;
    } finally {
      saving = false;
    }
  }

  function resetConfig() {
    thresholds = { ...originalThresholds };
    hasChanges = false;
    successMessage = '';
    error = null;
  }
</script>

<div class="config-container">
  <div class="card">
    <h2>⚙️ Threshold Configuration</h2>
    <p class="description">
      Adjust the alert thresholds for system monitoring. Changes are applied immediately to the monitoring service.
    </p>

    {#if loading}
      <div class="loading">
        <div class="spinner"></div>
        <p>Loading configuration...</p>
      </div>
    {:else if error}
      <div class="error-message">
        ⚠️ {error}
        <button on:click={loadConfig}>Retry</button>
      </div>
    {:else}
      <div class="sliders">
        <Slider
          label="RAM Threshold"
          bind:value={thresholds.ram_percent}
          min={10}
          max={100}
          step={1}
          onChange={handleRamChange}
        />

        <Slider
          label="CPU Threshold"
          bind:value={thresholds.cpu_percent}
          min={10}
          max={100}
          step={1}
          onChange={handleCpuChange}
        />

        <Slider
          label="Disk Threshold"
          bind:value={thresholds.disk_percent}
          min={10}
          max={100}
          step={1}
          onChange={handleDiskChange}
        />
      </div>

      {#if successMessage}
        <div class="success-message">
          ✓ {successMessage}
        </div>
      {/if}

      <div class="actions">
        <button
          on:click={saveConfig}
          disabled={!hasChanges || saving}
          class="save-button"
        >
          {saving ? 'Saving...' : 'Save Changes'}
        </button>
        
        <button
          on:click={resetConfig}
          disabled={!hasChanges || saving}
          class="reset-button"
        >
          Reset
        </button>
      </div>
    {/if}
  </div>
</div>

<style>
  .config-container {
    margin-bottom: 2rem;
  }

  h2 {
    font-size: 1.75rem;
    margin-bottom: 0.5rem;
    color: var(--text-primary);
  }

  .description {
    color: var(--text-secondary);
    margin-bottom: 2rem;
    font-size: 0.95rem;
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
    margin-bottom: 1rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .success-message {
    background: rgba(16, 185, 129, 0.1);
    border: 1px solid var(--accent-green);
    color: var(--accent-green);
    padding: 1rem;
    border-radius: 8px;
    margin-bottom: 1rem;
    animation: slideIn 0.3s ease;
  }

  @keyframes slideIn {
    from {
      opacity: 0;
      transform: translateY(-10px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .sliders {
    margin-bottom: 2rem;
  }

  .actions {
    display: flex;
    gap: 1rem;
  }

  .save-button {
    flex: 1;
    background: var(--accent-green);
  }

  .save-button:hover:not(:disabled) {
    background: #059669;
  }

  .reset-button {
    background: var(--bg-card);
    color: var(--text-primary);
  }

  .reset-button:hover:not(:disabled) {
    background: var(--border);
  }
</style>
