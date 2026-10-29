#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_root="$(mktemp -d /tmp/kurye-menu-test.XXXXXX)"
trap 'rm -rf "$test_root"' EXIT

export XDG_DATA_HOME="$test_root/data"
export XDG_CONFIG_HOME="$test_root/config"
export XDG_CACHE_HOME="$test_root/cache"

cd "$project_dir"
godot --headless --path . --import >"$test_root/import.log" 2>&1 || { cat "$test_root/import.log"; exit 1; }
godot --headless --path . --script res://tests/archive/menu_reset.gd
