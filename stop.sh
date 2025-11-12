#!/bin/bash
# Stop GlanceWatch script

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if glancewatch is running
if ! pgrep -f "glancewatch" > /dev/null; then
    echo -e "${YELLOW}⚠️  GlanceWatch is not running${NC}"
    exit 0
fi

echo -e "${YELLOW}🛑 Stopping GlanceWatch...${NC}"

# Show what we're stopping
echo ""
echo "Processes to stop:"
ps aux | grep -v grep | grep glancewatch
echo ""

# Kill glancewatch processes
pkill -f glancewatch

# Wait a moment
sleep 1

# Check if stopped
if ! pgrep -f "glancewatch" > /dev/null; then
    echo -e "${GREEN}✓ GlanceWatch stopped successfully${NC}"
else
    echo -e "${YELLOW}⚠️  Some processes still running, forcing stop...${NC}"
    pkill -9 -f glancewatch
    sleep 1
    
    if ! pgrep -f "glancewatch" > /dev/null; then
        echo -e "${GREEN}✓ GlanceWatch stopped (forced)${NC}"
    else
        echo -e "${RED}❌ Failed to stop GlanceWatch${NC}"
        echo "Try manually: sudo pkill -9 -f glancewatch"
        exit 1
    fi
fi
