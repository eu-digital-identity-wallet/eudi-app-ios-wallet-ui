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
build_settings=$(xcodebuild -project EudiReferenceWallet.xcodeproj -target Wallet  -showBuildSettings)

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

LOGIC_CORE_MODULE="logic-core"
LOGIC_BUSINESS_MODULE="logic-business"
LOGIC_ANALYTICS_MODULE="logic-analytics"
LOGIC_API_MODULE="logic-api"
LOGIC_UI_MODULE="logic-ui"
LOGIC_AUTH_MODULE="logic-authentication"

SECOND_LEVEL_MODULES=("${LOGIC_API_MODULE}" "${LOGIC_UI_MODULE}" "${LOGIC_AUTH_MODULE}")

FEATURE_COMMON_MODULE="feature-common"

FEATURE_MODULES=(
"feature-dashboard",
"feature-login",
"feature-startup",
"feature-presentation",
"feature-issuance",
"feature-proximity"
)

IS_BASE_LOGIC_MODULE=1
IS_SECONDARY_LOGIC_MODULE=2
IS_FEATURE_MODULE=3
HAS_NO_RELATIONS=4
IS_COMMON_FEATURE_MODULE=5

# Function Generator
function generateMocks {
  NEW_1=$(remove_last_comma "$1")

  OUTPUT_FILE="./Modules/$NEW_1/$2/Mock/GeneratedMocks.swift"
  printg "Generated Mocks File = ${OUTPUT_FILE}"

  INPUT_DIR="./Modules"
  
  echo "Mocks Input Directory = ${INPUT_DIR}"
  echo "Testable argument = $3"
  
  logic_core_path=""
  logic_business_path=""
  logic_ui_path=""
  logic_api_path=""
  logic_analytics_path=""
  logic_auth_path=""
  feature_common_path=""
  
  if [ $4 == $IS_SECONDARY_LOGIC_MODULE ];
    then
      logic_business_path="${INPUT_DIR}/${LOGIC_BUSINESS_MODULE}/Sources/**/*.swift"
      logic_analytics_path="${INPUT_DIR}/${LOGIC_ANALYTICS_MODULE}/Sources/**/*.swift"
      logic_core_path="${INPUT_DIR}/${LOGIC_CORE_MODULE}/Sources/**/*.swift"
  elif [ $4 == $IS_FEATURE_MODULE ];
    then
      logic_business_path="${INPUT_DIR}/${LOGIC_BUSINESS_MODULE}/Sources/**/*.swift"
      logic_analytics_path="${INPUT_DIR}/${LOGIC_ANALYTICS_MODULE}/Sources/**/*.swift"
      logic_api_path="${INPUT_DIR}/${LOGIC_API_MODULE}/Sources/**/*.swift"
      logic_ui_path="${INPUT_DIR}/${LOGIC_UI_MODULE}/Sources/**/*.swift"
      logic_core_path="${INPUT_DIR}/${LOGIC_CORE_MODULE}/Sources/**/*.swift"
      logic_auth_path="${INPUT_DIR}/${LOGIC_AUTH_MODULE}/Sources/**/*.swift"
      feature_common_path="${INPUT_DIR}/${FEATURE_COMMON_MODULE}/Sources/**/*.swift"
  elif [ $4 == $IS_COMMON_FEATURE_MODULE ];
    then
      logic_business_path="${INPUT_DIR}/${LOGIC_BUSINESS_MODULE}/Sources/**/*.swift"
      logic_analytics_path="${INPUT_DIR}/${LOGIC_ANALYTICS_MODULE}/Sources/**/*.swift"
      logic_api_path="${INPUT_DIR}/${LOGIC_API_MODULE}/Sources/**/*.swift"
      logic_ui_path="${INPUT_DIR}/${LOGIC_UI_MODULE}/Sources/**/*.swift"
      logic_core_path="${INPUT_DIR}/${LOGIC_CORE_MODULE}/Sources/**/*.swift"
      logic_auth_path="${INPUT_DIR}/${LOGIC_AUTH_MODULE}/Sources/**/*.swift"
  elif [ $4 == $IS_BASE_LOGIC_MODULE ];
    then
      logic_analytics_path="${INPUT_DIR}/${LOGIC_ANALYTICS_MODULE}/Sources/**/*.swift"
  fi

 "${PROJECT_DIR}/Mock/run" --download generate $3 --no-class-mocking --no-inheritance --no-header --glob \
  --output "${OUTPUT_FILE}" \
  "${INPUT_DIR}/$NEW_1/Sources/**/*.swift" \
  "$logic_business_path" \
  "$logic_ui_path" \
  "$logic_api_path" \
  "$logic_analytics_path" \
  "$logic_core_path" \
  "$logic_auth_path" \
  "$feature_common_path"
}

remove_last_comma() {
  local input="$1"
  local length=${#input}

  # Check if the last character is a comma
  if [ "${input: -1}" = "," ]; then
    # Remove the last character
    echo "${input:0:length-1}"
  else
    # No comma at the end, return the input string as is
    echo "$input"
  fi
}

# Logic Business
generateMocks $LOGIC_BUSINESS_MODULE "Tests" "--testable $LOGIC_BUSINESS_MODULE,$LOGIC_ANALYTICS_MODULE" $IS_BASE_LOGIC_MODULE

# Second level Logic Modules
for module in ${SECOND_LEVEL_MODULES[@]}; do
  generateMocks $module "Tests" "--testable $LOGIC_BUSINESS_MODULE,$LOGIC_ANALYTICS_MODULE,$LOGIC_CORE_MODULE,$module" $IS_SECONDARY_LOGIC_MODULE
done

# Feature Modules

delimiter=","
modulesToImport=""

for item in ${SECOND_LEVEL_MODULES[@]}; do
  modulesToImport+="$item$delimiter"
done

modulesToImport="${modulesToImport%$delimiter}"

# Feature Common Module
generateMocks $FEATURE_COMMON_MODULE "Tests" "--testable $LOGIC_BUSINESS_MODULE,$LOGIC_ANALYTICS_MODULE,$LOGIC_CORE_MODULE,$FEATURE_COMMON_MODULE,$modulesToImport" $IS_COMMON_FEATURE_MODULE

for module in ${FEATURE_MODULES[@]}; do
  NEW_MODULE=$(remove_last_comma "$module")
  generateMocks $module "Tests" "--testable $LOGIC_BUSINESS_MODULE,$LOGIC_ANALYTICS_MODULE,$LOGIC_CORE_MODULE,$NEW_MODULE,$modulesToImport" $IS_FEATURE_MODULE
done

