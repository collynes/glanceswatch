#!/bin/bash
# GlanceWatch Auto-Setup Script
# Automatically installs and starts GlanceWatch as a background service

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  GlanceWatch Auto-Setup${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Install GlanceWatch if not already installed
if ! command -v glancewatch &> /dev/null; then
    echo -e "${YELLOW}📦 Installing GlanceWatch...${NC}"
    pip install --user glancewatch
    echo -e "${GREEN}✓ GlanceWatch installed${NC}"
    echo ""
else
    echo -e "${YELLOW}📦 Upgrading GlanceWatch to latest version...${NC}"
    pip install --upgrade --user glancewatch
    echo -e "${GREEN}✓ GlanceWatch upgraded${NC}"
    echo ""
fi

# Determine the correct path to glancewatch binary
GLANCEWATCH_BIN=$(which glancewatch 2>/dev/null || echo "$HOME/.local/bin/glancewatch")

# Verify binary exists
if [ ! -f "$GLANCEWATCH_BIN" ]; then
    # Try to find it in common locations
    if [ -f "$HOME/.local/bin/glancewatch" ]; then
        GLANCEWATCH_BIN="$HOME/.local/bin/glancewatch"
        export PATH="$HOME/.local/bin:$PATH"
    else
        echo -e "${RED}❌ Error: glancewatch binary not found${NC}"
        echo "Expected location: $HOME/.local/bin/glancewatch"
        echo ""
        echo "Try adding to PATH:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        exit 1
    fi
fi

echo -e "${BLUE}GlanceWatch binary: $GLANCEWATCH_BIN${NC}"
echo ""

# Check if running on Linux with systemd
if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v systemctl &> /dev/null; then
    echo -e "${YELLOW}🔧 Detected systemd - installing as system service...${NC}"
    echo ""
    
    # Get current user
    CURRENT_USER=$(whoami)
    CURRENT_GROUP=$(id -gn)

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
Group=$CURRENT_GROUP
WorkingDirectory=$HOME
Environment="PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=$GLANCEWATCH_BIN --quiet
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

    # Stop any existing glancewatch processes
    if pgrep -f "glancewatch" > /dev/null; then
        echo -e "${YELLOW}Stopping existing GlanceWatch processes...${NC}"
        pkill -f glancewatch || true
        sleep 2
    fi

    # Enable and start the service
    echo -e "${YELLOW}Enabling and starting GlanceWatch service...${NC}"
    sudo systemctl enable glancewatch.service
    sudo systemctl start glancewatch.service
    echo -e "${GREEN}✓ Service started${NC}"
    echo ""

    # Wait a moment for service to start
    sleep 2

    # Check service status
    if systemctl is-active --quiet glancewatch.service; then
        echo -e "${GREEN}======================================${NC}"
        echo -e "${GREEN}  ✓ GlanceWatch is running!${NC}"
        echo -e "${GREEN}======================================${NC}"
        echo ""
        echo -e "${BLUE}Service Info:${NC}"
        echo "  • Runs automatically on boot"
        echo "  • Restarts automatically if crashes"
        echo "  • Logs to systemd journal"
        echo ""
        echo -e "${GREEN}Access the dashboard:${NC}"
        echo "  http://localhost:8000"
        if command -v hostname &> /dev/null; then
            EXTERNAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
            if [ -n "$EXTERNAL_IP" ]; then
                echo "  http://$EXTERNAL_IP:8000"
            fi
        fi
        echo ""
        echo -e "${YELLOW}Useful commands:${NC}"
        echo "  ${BLUE}sudo systemctl status glancewatch${NC}   # Check status"
        echo "  ${BLUE}sudo systemctl stop glancewatch${NC}     # Stop service"
        echo "  ${BLUE}sudo systemctl restart glancewatch${NC}  # Restart service"
        echo "  ${BLUE}sudo journalctl -u glancewatch -f${NC}   # View logs"
    else
        echo -e "${RED}❌ Service failed to start${NC}"
        echo "Check logs: sudo journalctl -u glancewatch -xe"
        exit 1
    fi

else
    # Fallback to nohup method
    echo -e "${YELLOW}🔧 systemd not available - using nohup background process...${NC}"
    echo ""
    
    # Stop any existing glancewatch processes
    if pgrep -f "glancewatch" > /dev/null; then
        echo -e "${YELLOW}Stopping existing GlanceWatch processes...${NC}"
        pkill -f glancewatch || true
        sleep 2
    fi
    
    # Start with nohup
    echo -e "${YELLOW}Starting GlanceWatch in background...${NC}"
    nohup $GLANCEWATCH_BIN > /dev/null 2>&1 &
    PID=$!
    
    # Wait a moment
    sleep 2
    
    # Check if it started
    if ps -p $PID > /dev/null 2>&1; then
        echo -e "${GREEN}✓ GlanceWatch started successfully!${NC}"
        echo ""
        echo -e "${GREEN}======================================${NC}"
        echo -e "${GREEN}  ✓ GlanceWatch is running!${NC}"
        echo -e "${GREEN}======================================${NC}"
        echo ""
        echo -e "${BLUE}Process Info:${NC}"
        echo "  • PID: $PID"
        echo "  • Running in background"
        echo "  • Survives terminal close"
        echo ""
        echo -e "${GREEN}Access the dashboard:${NC}"
        echo "  http://localhost:8000"
        if command -v hostname &> /dev/null; then
            EXTERNAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || hostname)
            if [ -n "$EXTERNAL_IP" ] && [ "$EXTERNAL_IP" != "hostname" ]; then
                echo "  http://$EXTERNAL_IP:8000"
            fi
        fi
        echo ""
        echo -e "${YELLOW}Useful commands:${NC}"
        echo "  ${BLUE}ps aux | grep glancewatch${NC}          # Check if running"
        echo "  ${BLUE}pkill -f glancewatch${NC}                # Stop service"
        echo "  ${BLUE}nohup glancewatch > /dev/null 2>&1 &${NC} # Start again"
        echo ""
        echo -e "${YELLOW}⚠️  Note: To auto-start on boot, consider adding systemd${NC}"
    else
        echo -e "${RED}❌ Failed to start GlanceWatch${NC}"
        echo "Try running manually: glancewatch"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}✅ Setup complete! You can now close this terminal.${NC}"