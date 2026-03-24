#!/bin/bash

# ─────────────────────────────────────────
#  O.P.M. Dashboard Launcher
#  Double-click this file to open your dashboard
# ─────────────────────────────────────────

OPM_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PORT=8765
URL="http://localhost:$PORT/portfolio_dashboard.html"

# Kill any process already using port 8765
echo "🔄  Checking for existing server on port $PORT..."
lsof -ti tcp:$PORT | xargs kill -9 2>/dev/null && echo "   Stopped old server." || echo "   Port is free."

# Start a fresh HTTP server in the background
echo "🚀  Starting dashboard server..."
cd "$OPM_DIR"
python3 -m http.server $PORT > /tmp/opm_server.log 2>&1 &
SERVER_PID=$!
echo "   Server PID: $SERVER_PID"

# Give the server a moment to start
sleep 1

# Open the dashboard in Chrome
echo "🌐  Opening dashboard in Chrome..."
open -a "Google Chrome" "$URL"

echo ""
echo "✅  Dashboard is live at: $URL"
echo "   (Close this window any time — the server keeps running.)"
echo ""
echo "   To stop the server later, run:"
echo "   lsof -ti tcp:$PORT | xargs kill -9"
