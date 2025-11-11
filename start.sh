#!/bin/bash
# Quick start script for GlanceWatch

echo "🎯 Starting GlanceWatch..."
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    exit 1
fi

# Install dependencies if needed
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
else
    source venv/bin/activate
fi

echo "🚀 Starting GlanceWatch on http://localhost:8000"
echo "📖 API docs available at http://localhost:8000/docs"
echo ""
python3 -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
