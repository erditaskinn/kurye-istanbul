#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tools_dir="/workspace/.kurye-tools"

if [[ ! -f "$tools_dir/xdg/data/godot/export_templates/4.6.3.stable/android_debug.apk" || ! -x "$tools_dir/android/build-tools/35.0.1/apksigner" ]]; then
  echo "Android tools are missing from $tools_dir" >&2
  exit 1
fi

export XDG_DATA_HOME="$tools_dir/xdg/data"
export XDG_CONFIG_HOME="$tools_dir/xdg/config"
export XDG_CACHE_HOME="$tools_dir/xdg/cache"
export ANDROID_USER_HOME="$tools_dir/android/user"

cd "$project_dir"
mkdir -p build
godot --headless --path . --import > build/import.log 2>&1 || { cat build/import.log; exit 1; }
godot --headless --path . --export-debug Android build/istanbul-kurye-debug.apk
"$tools_dir/android/build-tools/35.0.1/apksigner" verify build/istanbul-kurye-debug.apk
echo "Built $project_dir/build/istanbul-kurye-debug.apk"
