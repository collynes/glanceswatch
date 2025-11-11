<script>
  import Dashboard from './Dashboard.svelte';
  import Config from './Config.svelte';
</script>

<main>
  <header>
    <h1>🔍 GlanceWatch</h1>
    <p class="tagline">Lightweight System Monitoring</p>
  </header>

  <Dashboard />
  <Config />

  <footer>
    <p>GlanceWatch v1.0.0 | Powered by Glances + Uptime Kuma</p>
  </footer>
</main>

<style>
  main {
    min-height: 100vh;
  }

  header {
    text-align: center;
    margin-bottom: 3rem;
    padding-top: 2rem;
  }

  h1 {
    font-size: 3rem;
    font-weight: 800;
    background: linear-gradient(135deg, var(--accent-blue), var(--accent-green));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 0.5rem;
  }

  .tagline {
    color: var(--text-secondary);
    font-size: 1.1rem;
  }

  footer {
    text-align: center;
    padding: 2rem 0;
    color: var(--text-secondary);
    font-size: 0.85rem;
    border-top: 1px solid var(--border);
    margin-top: 2rem;
  }
</style>
