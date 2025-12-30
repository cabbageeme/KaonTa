# App Logo Setup Instructions

## Required Action

Please save the KaonTa logo image (the one with the fork, chat bubble, and location pin) as:
`logo.png`

Place it in this folder: `assets/images/logo.png`

## Image Requirements

- Format: PNG (recommended) or JPG
- Recommended size: 1024x1024 pixels (or any square dimension)
- Background: Transparent PNG is ideal, but white background works too

## After Adding the Logo

1. Run `flutter pub get` to download the flutter_launcher_icons package
2. Run `dart run flutter_launcher_icons` to generate app icons for Android and iOS
3. The logo will automatically appear in:
   - Splash screen when app starts
   - App icon on your phone's home screen (after building and installing)

## Testing

Run the app to see the logo in the splash screen:
```bash
flutter run
```

Build and install to see the app icon on your device:
```bash
flutter build apk
# or
flutter build ios
```
