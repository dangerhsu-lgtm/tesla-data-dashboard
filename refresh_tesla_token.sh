#!/bin/bash

# Configuration
TOKEN_FILE="/Users/danny/tesla-data-dashboard/tesla-token.json"
LOG_FILE="/Users/danny/tesla-data-dashboard/tesla-token-refresh.log"
CLIENT_ID="09117961-fb86-4b2b-8fd9-0b7f738f66fc"
AUTH_URL="https://auth.tesla.cn/oauth2/v3/token"

# Ensure Python is available for JSON parsing
if ! command -v python3 &> /dev/null; then
    echo "$(date): Error - python3 not found." >> "$LOG_FILE"
    exit 1
fi

# Read Refresh Token
if [ -f "$TOKEN_FILE" ]; then
    REFRESH_TOKEN=$(python3 -c "import json, sys; print(json.load(open('$TOKEN_FILE')).get('refresh_token', ''))" 2>> "$LOG_FILE")
else
    echo "$(date): Error - Token file not found at $TOKEN_FILE" >> "$LOG_FILE"
    exit 1
fi

if [ -z "$REFRESH_TOKEN" ]; then
    echo "$(date): Error - No refresh token found in $TOKEN_FILE" >> "$LOG_FILE"
    exit 1
fi

# Refresh Token
RESPONSE=$(curl --silent --show-error --request POST \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=refresh_token' \
  --data-urlencode "client_id=$CLIENT_ID" \
  --data-urlencode "refresh_token=$REFRESH_TOKEN" \
  "$AUTH_URL")

# Check for success (look for access_token in response)
if echo "$RESPONSE" | grep -q "access_token"; then
    echo "$RESPONSE" > "$TOKEN_FILE"
    echo "$(date): Token refreshed successfully." >> "$LOG_FILE"

else
    echo "$(date): Error - Failed to refresh token. Response: $RESPONSE" >> "$LOG_FILE"
    exit 1
fi

