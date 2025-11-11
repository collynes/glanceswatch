<script>
  export let label;
  export let value;
  export let min = 0;
  export let max = 100;
  export let step = 1;
  export let unit = '%';
  export let onChange;

  function handleChange(event) {
    const newValue = parseFloat(event.target.value);
    if (onChange) onChange(newValue);
  }

  $: displayValue = `${value}${unit}`;
  $: percentage = ((value - min) / (max - min)) * 100;
  $: gradientColor = percentage > 80 ? 'var(--accent-red)' : percentage > 60 ? 'var(--accent-yellow)' : 'var(--accent-green)';
</script>

<div class="slider-container">
  <div class="slider-header">
    <label for={label}>{label}</label>
    <span class="value" style="color: {gradientColor}">{displayValue}</span>
  </div>
  <div class="slider-track-wrapper">
    <div class="slider-track-fill" style="width: {percentage}%; background: {gradientColor}"></div>
    <input
      type="range"
      id={label}
      {min}
      {max}
      {step}
      bind:value
      on:input={handleChange}
      class="slider"
    />
  </div>
</div>

<style>
  .slider-container {
    margin-bottom: 1.5rem;
  }

  .slider-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.75rem;
  }

  label {
    font-size: 1rem;
    font-weight: 600;
    color: var(--text-primary);
  }

  .value {
    font-size: 1.25rem;
    font-weight: 700;
    min-width: 60px;
    text-align: right;
  }

  .slider-track-wrapper {
    position: relative;
    height: 8px;
  }

  .slider-track-fill {
    position: absolute;
    height: 100%;
    border-radius: 4px;
    transition: all 0.3s ease;
    pointer-events: none;
    z-index: 1;
  }

  .slider {
    position: relative;
    z-index: 2;
  }
</style>
