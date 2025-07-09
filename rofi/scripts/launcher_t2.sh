#!/usr/bin/env bash

## Run
rofi \
    -show drun \
    -theme "$(dirname $(dirname "$(realpath "$0")"))/configs/launcher.rasi" \
	-mouse-selection enabled
