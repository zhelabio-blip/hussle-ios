#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Configs/Secrets.xcconfig"
if [[ ! -f "$FILE" ]]; then
  echo "MISSING: Configs/Secrets.xcconfig"
  echo "Copy the working Secrets.xcconfig from your previous Hussle build, or duplicate Secrets.xcconfig.example and insert Project URL + Publishable key."
  exit 1
fi
URL=$(awk -F= '/^[[:space:]]*SUPABASE_URL[[:space:]]*=/{sub(/^[^=]*=/,""); gsub(/[[:space:]]/,""); print; exit}' "$FILE")
KEY=$(awk -F= '/^[[:space:]]*SUPABASE_ANON_KEY[[:space:]]*=/{sub(/^[^=]*=/,""); gsub(/[[:space:]]/,""); print; exit}' "$FILE")
URL=${URL//\$\(\)/\/}
if [[ ! "$URL" =~ ^https://[a-z0-9]+\.supabase\.co/?$ ]]; then
  echo "INVALID: SUPABASE_URL"
  exit 1
fi
if [[ ! "$KEY" =~ ^sb_publishable_ ]]; then
  echo "INVALID: SUPABASE_ANON_KEY must be the Publishable key"
  exit 1
fi
echo "PASS: local Supabase configuration is present and valid."
