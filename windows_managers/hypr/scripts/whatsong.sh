#!/bin/bash
echo "$(playerctl metadata --format='{{ artist }} - {{ title }}' 2>/dev/null || echo '')"
