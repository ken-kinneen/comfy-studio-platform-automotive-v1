#!/bin/bash
set -e

BOOT_START=$(date +%s.%N)

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  🚀 COMFYUI WORKER STARTING - $(date '+%Y-%m-%d %H:%M:%S')      ║"
echo "╚══════════════════════════════════════════════════════════════╝"

echo "🔧 HF_TOKEN: ${HF_TOKEN:+SET}${HF_TOKEN:-NOT SET}"
echo "💾 Volume: $(df -h /runpod-volume 2>/dev/null | tail -1 | awk '{print $3 "/" $4}' || echo 'N/A')"

# Download models if needed
/download-models.sh

BOOT_END=$(date +%s.%N)
echo "⏱️  Boot time: $(echo "$BOOT_END - $BOOT_START" | bc)s"

exec python -u /handler.py
