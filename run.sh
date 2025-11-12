#!/bin/bash
set -e

# Go to repo root (the folder where this script lives)
cd "$(dirname "$0")"

# Create or reuse venv
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi

# Activate venv
source venv/bin/activate

# Upgrade pip and install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Restart FastAPI app (kill old one if running)
if pgrep -f "uvicorn main:app" > /dev/null; then
  pkill -f "uvicorn main:app"
fi

# Start FastAPI in background
# Write logs inside a "logs" folder in repo root
mkdir -p logs
nohup uvicorn main:app --host 0.0.0.0 --port 8000 > logs/app.log 2>&1 &

echo "FastAPI running on http://localhost:8000"
echo "Logs at $(pwd)/logs/app.log"
