#!/usr/bin/env bash

set -eu

PWD=$(pwd)
TIMESTAMP="${TIMESTAMP:-$(date -u +"%Y%m%d%H%M%S")}"

# West Build (left)
west build -s zmk/app -d build/left -b "nice_nano_v2" -- -DZMK_CONFIG="${PWD}/config" -DSHIELD="pepijno_left nice_view_adapter nice_view"
grep -v -e "^#" -e "^$" build/left/zephyr/.config | sort
# West Build (right)
west build -s zmk/app -d build/right -b "nice_nano_v2" -- -DZMK_CONFIG="${PWD}/config" -DSHIELD="pepijno_right nice_view_adapter nice_view"
grep -v -e "^#" -e "^$" build/right/zephyr/.config | sort
# West build reset
west build -s zmk/app -d build/reset -b "nice_nano_v2" -- -DZMK_CONFIG="${PWD}/config" -DSHIELD="settings_reset"
# Rename zmk.uf2
cp build/left/zephyr/zmk.uf2 ./firmware/${TIMESTAMP}-left.uf2 && cp build/right/zephyr/zmk.uf2 ./firmware/${TIMESTAMP}-right.uf2 && cp build/reset/zephyr/zmk.uf2 ./firmware/${TIMESTAMP}-reset.uf2
