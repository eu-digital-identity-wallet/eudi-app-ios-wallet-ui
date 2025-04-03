#!/bin/sh

# Exit on error (-e), undefined vars (-u), and pipeline failures (-o pipefail)
set -euo pipefail

defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
