#!/usr/bin/env node

const { spawn } = require('child_process');
const os = require('os');

// Determine Python command
let pythonCmd = 'python3';
try {
  require('child_process').execSync('python3 --version', { stdio: 'ignore' });
} catch {
  pythonCmd = 'python';
}

// Forward all arguments to glancewatch
const args = process.argv.slice(2);
const glancewatch = spawn(pythonCmd, ['-m', 'app.main', ...args], {
  stdio: 'inherit',
  shell: true
});

glancewatch.on('error', (err) => {
  console.error('Failed to start GlanceWatch:', err);
  process.exit(1);
});

glancewatch.on('exit', (code) => {
  process.exit(code);
});
