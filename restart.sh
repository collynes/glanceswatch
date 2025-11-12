#!/bin/bash
# Restart GlanceWatch script

echo "🔄 Restarting GlanceWatch..."
echo ""

# Stop first
./stop.sh

# Wait a moment
sleep 1

# Start again
./start.sh "$@"
