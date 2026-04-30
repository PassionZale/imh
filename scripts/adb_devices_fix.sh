#!/bin/bash

echo "🔍 Searching for connected devices..."

# Get first physical device (exclude emulators)
DEVICE_ID=$(adb devices | awk 'NR>1 && $2=="device" && $1 !~ /^emulator/ {print $1; exit}')

if [ -z "$DEVICE_ID" ]; then
  echo "ℹ️ No Android device connected, skipping ADB fix"
  exit 0
fi

# Check manufacturer
MANUFACTURER=$(adb -s "$DEVICE_ID" shell getprop ro.product.manufacturer | tr -d '\r')
DEVICE_NAME=$(adb -s "$DEVICE_ID" shell getprop ro.product.name)

echo "📱 Found device $MANUFACTURER $DEVICE_NAME: $DEVICE_ID"

# Only apply to Honor/Huawei
if [[ "$MANUFACTURER" =~ HONOR|Honor|HUAWEI|Huawei|NUBIA|Nubia ]]; then
  echo "🔎 Checking current log level..."

  CURRENT_LOG=$(adb -s "$DEVICE_ID" shell getprop persist.log.tag | tr -d '\r')
  echo "Current persist.log.tag: '$CURRENT_LOG'"

  if [ "$CURRENT_LOG" = "I" ]; then
    echo "✅ No fix needed, log level is already set to 'I'"
  else
    echo "⚙️ Applying fix for $MANUFACTURER device..."

    adb -s "$DEVICE_ID" wait-for-device
    adb -s "$DEVICE_ID" shell setprop persist.log.tag I

    echo "🔎 Verifying property:"
    adb -s "$DEVICE_ID" shell getprop persist.log.tag

    echo "🚀 Fix applied – debugging should now work"
  fi

else
  echo "⚠️ Not an Honor/Huawei/Nubia device – no fix needed"
fi
