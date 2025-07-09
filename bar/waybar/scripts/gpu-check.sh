#!/bin/bash
if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n1
else
    # Return empty or exit with error code to hide widget
    exit 1
fi
