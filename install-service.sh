#!/bin/bash
# GlanceWatch Auto-Setup Script
# This script installs GlanceWatch as a systemd service

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  GlanceWatch Auto-Setup${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo -e "${RED}Error: This script is for Linux systems only.${NC}"
    echo "For other systems, please run 'glancewatch' manually."
    exit 1
fi

# Check if systemd is available
if ! command -v systemctl &> /dev/null; then
    echo -e "${RED}Error: systemd not found. Please run 'glancewatch' manually.${NC}"
    exit 1
fi

# Install GlanceWatch if not already installed
if ! command -v glancewatch &> /dev/null; then
    echo -e "${YELLOW}Installing GlanceWatch...${NC}"
    pip install --user glancewatch
    echo -e "${GREEN}✓ GlanceWatch installed${NC}"
else
    echo -e "${GREEN}✓ GlanceWatch already installed${NC}"
fi

# Determine the correct path to glancewatch binary
GLANCEWATCH_BIN=$(which glancewatch)
echo "GlanceWatch binary: $GLANCEWATCH_BIN"

# Get current user
CURRENT_USER=$(whoami)

# Create systemd service file
SERVICE_FILE="/tmp/glancewatch.service"
cat > "$SERVICE_FILE" << EOF
[Unit]
Description=GlanceWatch - System Monitoring Dashboard
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=$CURRENT_USER
Group=$CURRENT_USER
WorkingDirectory=$HOME
Environment="PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=$GLANCEWATCH_BIN
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=glancewatch

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=$HOME/.config/glancewatch

[Install]
WantedBy=multi-user.target
EOF

# Install the service
echo -e "${YELLOW}Installing systemd service...${NC}"
sudo cp "$SERVICE_FILE" /etc/systemd/system/glancewatch.service
sudo systemctl daemon-reload
echo -e "${GREEN}✓ Service file installed${NC}"

# Enable and start the service
echo -e "${YELLOW}Enabling and starting GlanceWatch service...${NC}"
sudo systemctl enable glancewatch.service
sudo systemctl start glancewatch.service
echo -e "${GREEN}✓ Service started${NC}"

# Wait a moment for service to start
sleep 2

# Check service status
if systemctl is-active --quiet glancewatch.service; then
    echo ""
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}  ✓ GlanceWatch is running!${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo ""
    echo "Service status:"
    sudo systemctl status glancewatch.service --no-pager -l
    echo ""
    echo -e "${GREEN}Access the dashboard at:${NC}"
    echo "  http://localhost:8000"
    echo "  http://$(hostname -I | awk '{print $1}'):8000"
    echo ""
    echo "Useful commands:"
    echo "  sudo systemctl status glancewatch   # Check status"
    echo "  sudo systemctl stop glancewatch     # Stop service"
    echo "  sudo systemctl start glancewatch    # Start service"
    echo "  sudo systemctl restart glancewatch  # Restart service"
    echo "  sudo journalctl -u glancewatch -f   # View logs"
else
    echo -e "${RED}Error: Service failed to start${NC}"
    echo "Check logs with: sudo journalctl -u glancewatch -xe"
    exit 1
fi
