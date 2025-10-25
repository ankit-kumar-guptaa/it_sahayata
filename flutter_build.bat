@echo off
echo 🔄 Cleaning Flutter project...

REM Step 1: Flutter clean
flutter clean

REM Step 2: Delete build and .dart_tool folders manually
echo 🧹 Removing build and .dart_tool folders...
rmdir /s /q build
rmdir /s /q .dart_tool
del /f /q pubspec.lock

REM Step 3: Clear pub cache
echo 🧼 Clearing Flutter pub cache...
flutter pub cache clear

REM Step 4: Get dependencies again
echo 📦 Running flutter pub get...
flutter pub get

REM Step 5: Build APK
echo 🛠️ Building APK...
flutter build apk --no-shrink

echo ✅ Done! APK build complete.
pause
