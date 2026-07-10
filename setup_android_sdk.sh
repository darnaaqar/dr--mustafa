#!/bin/bash
set -e

echo "=== Installing Java and dependencies (Non-Interactive) ==="
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" openjdk-17-jdk-headless unzip wget

echo "=== Downloading Android Command Line Tools ==="
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip

echo "=== Extracting Android Command Line Tools ==="
mkdir -p /opt/android-sdk/cmdline-tools
rm -rf /opt/android-sdk/cmdline-tools/latest
unzip -q /tmp/cmdline-tools.zip -d /opt/android-sdk/cmdline-tools
mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest

echo "=== Accepting Android Licenses ==="
yes | /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=/opt/android-sdk

echo "=== Installing SDK components ==="
/opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --sdk_root=/opt/android-sdk "platforms;android-34" "build-tools;34.0.0" "platform-tools"

echo "=== Configuring Flutter with Android SDK ==="
/opt/flutter/bin/flutter config --android-sdk /opt/android-sdk

echo "=== Android SDK setup completed successfully! ==="
