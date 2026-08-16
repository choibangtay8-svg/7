#!/usr/bin/env bash
clear

set -e

# Cleanup biến cũ trong session hiện tại
for var in PROVIDER_ID PROVIDER_NAME MODEL_ID BASE_URL KEY_ENV WIRE_API REASONING_EFFORT API_KEY; do
    unset "$var" || true
done

mkdir -p ~/.codex


read -rp "Provider ID (ví dụ: porn): " PROVIDER_ID
PROVIDER_ID=${PROVIDER_ID:-porn}

read -rp "Provider name (ví dụ: Porn): " PROVIDER_NAME
PROVIDER_NAME=${PROVIDER_NAME:-Porn}

read -rp "Model ID (ví dụ: gpt-5.6-luna): " MODEL_ID
MODEL_ID=${MODEL_ID:-gpt-5.6-luna}

read -rp "Base URL: " BASE_URL
BASE_URL=${BASE_URL:-https://api.pornhub.com/v1}

read -rp "API key env name (ví dụ: PORN_API_KEY): " KEY_ENV
KEY_ENV=${KEY_ENV:-PORN_API_KEY}

read -rp "Wire API (responses/chat_completions): " WIRE_API
WIRE_API=${WIRE_API:-responses}

read -rp "Reasoning effort (low/medium/high/max/ultra) [medium]: " REASONING_EFFORT
REASONING_EFFORT=${REASONING_EFFORT:-medium}


echo
read -rsp "Nhập API key mới: " API_KEY
echo


# Xóa toàn bộ API key export cũ tránh duplicate
sed -i \
-e '/^[[:space:]]*export[[:space:]]\+.*_API_KEY=/d' \
-e '/^[[:space:]]*export[[:space:]]\+.*_KEY=/d' \
~/.bashrc || true


# Lưu key an toàn
printf 'export %s=%q\n' "$KEY_ENV" "$API_KEY" >> ~/.bashrc


# Apply ngay session hiện tại
export "$KEY_ENV=$API_KEY"


# Backup config cũ
if [ -f ~/.codex/config.toml ]; then
    mv ~/.codex/config.toml ~/.codex/config.toml.backup.$(date +%s)
fi


# Generate config mới
cat > ~/.codex/config.toml <<EOF
model = "$MODEL_ID"
model_provider = "$PROVIDER_ID"
model_reasoning_effort = "$REASONING_EFFORT"

[model_providers.$PROVIDER_ID]
name = "$PROVIDER_NAME"
base_url = "$BASE_URL"
wire_api = "$WIRE_API"
supports_websockets = false

[model_providers.$PROVIDER_ID.auth]
command = "/bin/bash"
args = ["-ic", "printenv $KEY_ENV"]
EOF


echo
echo "================================="
echo "Codex provider setup complete"
echo "Provider : $PROVIDER_NAME"
echo "Model    : $MODEL_ID"
echo "URL      : $BASE_URL"
echo "Effort   : $REASONING_EFFORT"
echo "Config   : ~/.codex/config.toml"
echo "================================="
