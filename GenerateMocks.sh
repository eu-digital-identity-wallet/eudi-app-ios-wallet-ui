# Colors
printy() {
  printf "\e[33;1m%s\n" "$1"
}
printg() {
  printf "\e[32m$1\e[m\n"
}
printr() {
  echo -e "\033[1;31m$1\033[0m"
}

# Use xcodebuild to load build settings into environment variables
build_settings=$(xcodebuild -project EudiReferenceWallet.xcodeproj -target EudiWallet  -showBuildSettings)

# Set specific build settings as environment variables
export ACTION=$(echo "$build_settings" | awk -F'=' '/ACTION/{print $2}' | tr -d ' ')
export PROJECT_DIR=$(echo "$build_settings" | awk -F'=' '/PROJECT_DIR/{print $2}' | tr -d ' ')
export INPUT_DIR=$(echo "$build_settings" | awk -F'=' '/INPUT_DIR/{print $2}' | tr -d ' ')

# Type a script or drag a script file from your workspace to insert its path.
if [ $ACTION == "indexbuild" ]; then
  printr "Not running Cuckoo generator during indexing."
  exit 0
fi

# Skip for preview builds
if [ "${ENABLE_PREVIEWS}" = "YES" ]; then
  printr "Not running Cuckoo generator during preview builds."
  exit 0
fi

# Run Cuckoo Script
"${PROJECT_DIR}/Cuckoo/run" --configuration "${PROJECT_DIR}/CuckooConfig.toml"
