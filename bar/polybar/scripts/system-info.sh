#!/bin/bash
# System Info Script for Polybar
# Shows RAM, CPU, and GPU usage

# Get RAM usage
ram_used=$(free -h | awk '/^Mem:/ {print $3}')
ram_total=$(free -h | awk '/^Mem:/ {print $2}')

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# Get GPU usage (NVIDIA)
if command -v nvidia-smi &> /dev/null; then
    gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -1)
    gpu_info="%{F#A3BE8C} GPU: ${gpu_usage}%%{F-}"
elif command -v radeontop &> /dev/null; then
    # For AMD GPUs - requires radeontop
    gpu_usage=$(timeout 1 radeontop -d - -l 1 | grep -o "gpu [0-9]*" | cut -d' ' -f2)
    gpu_info="%{F#A3BE8C} GPU: ${gpu_usage}%%{F-}"
else
    gpu_info=""
fi

# Format output
echo "%{F#D08770} RAM: ${ram_used}/${ram_total}%{F-} %{F#EBCB8B} CPU: ${cpu_usage}%{F-} ${gpu_info}"
