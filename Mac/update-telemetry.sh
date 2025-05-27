#!/bin/bash
set -e

FILE="/Users/nht/Library/Application Support/Windsurf/User/globalStorage/storage.json"
TMP="$FILE.tmp"

if [ ! -f "$FILE" ]; then
  echo "File does not exist: $FILE"
  exit 1
fi

cp "$FILE" "$FILE.bak"

# Tạo machineId 64 ký tự hex
MACHINE_ID=$(LC_CTYPE=C hexdump -n 32 -e '"%02x"' /dev/urandom)
# Tạo sqmId và deviceId dạng UUID không có dấu ngoặc nhọn
SQM_ID=$(uuidgen | tr 'A-Z' 'a-z' | tr -d '{}')
DEVICE_ID=$(uuidgen | tr 'A-Z' 'a-z' | tr -d '{}')

# Thay thế các trường telemetry trong file JSON
JSON=$(cat "$FILE")
JSON=$(echo "$JSON" | LC_ALL=C sed -E "s/\"telemetry\\.machineId\"[ ]*:[ ]*\"[^\"]*\"/\"telemetry.machineId\": \"$MACHINE_ID\"/")
JSON=$(echo "$JSON" | LC_ALL=C sed -E "s/\"telemetry\\.sqmId\"[ ]*:[ ]*\"[^\"]*\"/\"telemetry.sqmId\": \"$SQM_ID\"/")
JSON=$(echo "$JSON" | LC_ALL=C sed -E "s/\"telemetry\\.devDeviceId\"[ ]*:[ ]*\"[^\"]*\"/\"telemetry.devDeviceId\": \"$DEVICE_ID\"/")

echo "$JSON" > "$TMP"

if [ -f "$TMP" ]; then
  mv "$TMP" "$FILE"
  echo -e "\nTelemetry updated successfully!"
  echo "machineId : $MACHINE_ID"
  echo "sqmId     : {$SQM_ID}"
  echo "deviceId  : $DEVICE_ID"
else
  echo "Failed to create temporary file."
  exit 1
fi

echo -e "\nPress Enter to exit..."
read