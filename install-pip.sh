#!/bin/bash
# GlanceWatch pip installation script for Ubuntu
# Usage: curl -sSL https://raw.githubusercontent.com/collinskramp/glancewatch/main/install-pip.sh | bash

set -e

echo "🎯 Installing GlanceWatch..."
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8+ first."
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "✓ Found Python $PYTHON_VERSION"

# Check if Glances is installed
if ! command -v glances &> /dev/null; then
    echo ""
    echo "📦 Glances not found. Installing..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -qq
        sudo apt-get install -y -qq glances
        echo "✓ Glances installed via apt"
    else
        pip3 install --user glances
        echo "✓ Glances installed via pip"
    fi
else
    echo "✓ Glances already installed"
fi

# Check if Glances is running
if ! pgrep -x "glances" > /dev/null; then
    echo ""
    echo "🚀 Starting Glances API server..."
    
    # Create systemd service for Glances
    sudo tee /etc/systemd/system/glances.service > /dev/null <<EOF
[Unit]
Description=Glances API Server
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=$(which glances) -w
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable glances
    sudo systemctl start glances
    echo "✓ Glances service created and started"
else
    echo "✓ Glances is already running"
fi

# Install GlanceWatch
echo ""
echo "📦 Installing GlanceWatch..."
pip3 install --user glancewatch
echo "✓ GlanceWatch installed"

# Get the installation path
GLANCEWATCH_PATH=$(python3 -c "import sys; import os; print(os.path.join(sys.prefix if hasattr(sys, 'real_prefix') else os.path.expanduser('~/.local'), 'bin', 'glancewatch'))")

# Create systemd service for GlanceWatch
echo ""
echo "🔧 Creating GlanceWatch service..."
sudo tee /etc/systemd/system/glancewatch.service > /dev/null <<EOF
[Unit]
Description=GlanceWatch Monitoring Service
After=network.target glances.service
Requires=glances.service

[Service]
Type=simple
User=$USER
ExecStart=$GLANCEWATCH_PATH
Restart=always
RestartSec=10
Environment="PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable glancewatch
sudo systemctl start glancewatch
echo "✓ GlanceWatch service created and started"

# Wait a moment for services to start
sleep 2

# Check service status
echo ""
echo "📊 Service Status:"
echo ""
sudo systemctl status glances --no-pager -l | head -n 5
echo ""
sudo systemctl status glancewatch --no-pager -l | head -n 5

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

# Final instructions
echo ""
echo "✅ Installation Complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 Access GlanceWatch:"
echo "   Web UI:  http://$SERVER_IP:8000/configure/"
echo "   API:     http://$SERVER_IP:8000/status"
echo "   Docs:    http://$SERVER_IP:8000/docs"
echo ""
echo "🔗 For Uptime Kuma, use:"
echo "   http://$SERVER_IP:8000/status"
echo ""
echo "📋 Useful Commands:"
echo "   sudo systemctl status glancewatch"
echo "   sudo systemctl restart glancewatch"
echo "   sudo systemctl logs -f glancewatch"
echo "   curl http://localhost:8000/status"
echo ""
echo "📚 Documentation:"
echo "   https://github.com/collinskramp/glancewatch"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
