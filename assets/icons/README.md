# App Icon Setup Guide

## 📱 How to Add Your App Logo

### Step 1: Prepare Your Icon Image

1. **Create or obtain your app logo/icon**
   - Should be a square image (1024x1024 pixels recommended)
   - Format: PNG with transparency support
   - High quality, clear, and recognizable
   - No text that's too small to read at small sizes

2. **Save your icon file**:
   - Save it as `app_icon.png`
   - Place it in this directory: `assets/icons/app_icon.png`

### Step 2: Customize Colors (Optional)

If you want to customize the Android adaptive icon background color, edit `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  adaptive_icon_background: "#YOUR_COLOR_HEX"  # e.g., "#4A90E2" for blue
```

### Step 3: Generate Icons

After placing your `app_icon.png` file in this directory, run:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This will automatically generate all required icon sizes for:
- ✅ Android (all density folders)
- ✅ iOS (all required sizes)
- ✅ Adaptive icons for Android 8.0+
- ✅ Web icons

### Step 4: Verify

After generation, you can verify the icons were created:
- **Android**: Check `android/app/src/main/res/mipmap-*/ic_launcher.png`
- **iOS**: Check `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Icon Requirements

- **Minimum size**: 1024x1024 pixels
- **Format**: PNG (with or without transparency)
- **Recommended**: Square image with safe zone (keep important content in center 80% of image)

### Tips

- Keep your logo centered and simple
- Avoid thin lines or small text
- Test how it looks at small sizes
- Use high contrast for visibility on different backgrounds

### Troubleshooting

If icons don't appear after generation:
1. Run `flutter clean`
2. Delete the build folder
3. Run `flutter pub run flutter_launcher_icons` again
4. Rebuild your app

