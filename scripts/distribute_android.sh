#!/bin/bash

# Exit on error
set -e

echo "🚀 Memulai proses distribusi ke Firebase App Distribution..."

# 1. Build APK
echo "📦 Membangun APK Release..."
flutter build apk --release

# 2. Set App ID secara manual (lebih stabil)
APP_ID="1:24480396862:android:57d8e2265836eaad3a836f"

echo "📤 Mengunggah APK ke Firebase App Distribution (App ID: $APP_ID)..."
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
    --app "$APP_ID" \
    --groups "testers"

echo "✅ Distribusi selesai!"
