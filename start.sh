#!/bin/bash
# Quick start script - runs GlanceWatch in background using nohup
# Usage: ./start.sh [OPTIONS]
#
# Examples:
#   ./start.sh                    # Start with defaults
#   ./start.sh --port 8080        # Start on different port
#   ./start.sh --verbose          # Start with verbose logging

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if glancewatch is already running
if pgrep -f "glancewatch" > /dev/null; then
    echo -e "${YELLOW}⚠️  GlanceWatch is already running${NC}"
    echo ""
    echo "Process details:"
    ps aux | grep -v grep | grep glancewatch
    echo ""
    echo "To stop it: pkill -f glancewatch"
    exit 0
fi

# Check if glancewatch is installed
if ! command -v glancewatch &> /dev/null; then
    echo -e "${RED}❌ GlanceWatch is not installed${NC}"
    echo ""
    echo "Install it with one of these methods:"
    echo "  pip install glancewatch         # Global install"
    echo "  pip install --user glancewatch  # User install"
    echo ""
    exit 1
fi

# Parse arguments
ARGS="$@"

# Start glancewatch in background
echo -e "${GREEN}🚀 Starting GlanceWatch in background...${NC}"
nohup glancewatch $ARGS > /dev/null 2>&1 &
PID=$!

# Wait a moment
sleep 2

# Check if it started successfully
if ps -p $PID > /dev/null 2>&1; then
    echo -e "${GREEN}✓ GlanceWatch started successfully!${NC}"
    echo ""
    echo "PID: $PID"
    echo "Dashboard: http://localhost:8000/"
    echo ""
    echo -e "${YELLOW}Useful commands:${NC}"
    echo "  pkill -f glancewatch            # Stop GlanceWatch"
    echo "  ps aux | grep glancewatch       # Check if running"
    echo "  tail -f ~/.config/glancewatch/* # View logs (if any)"
    echo ""
    echo -e "${GREEN}✅ You can now close this terminal safely.${NC}"
else
    echo -e "${RED}❌ Failed to start GlanceWatch${NC}"
    echo "Try running manually to see errors: glancewatch"
    exit 1
fi