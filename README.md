# KaonTa (Karinderia Spotlight)

A Flutter application for discovering and engaging with local food spots. Includes authentication, role-based flows, and persistent storage.

## Project Overview
- Framework: Flutter (Material 3)
- Platforms: Android, iOS, Web, Windows (web requires extra Firebase setup)
- Core Features: Splash → Welcome → Auth (Login/Signup) → User Type selection → Role dashboards
- Data: Firebase Auth + Cloud Firestore (mobile/desktop). Web requires Firebase configuration.

## Rubric Compliance Checklist
- Functionality: Authentication (mobile/password; email synthesized internally), role navigation, basic validations (password length, confirm match, phone format).
- Data Persistence: Users saved to Firestore on signup.
- UX/UI: Splash animation, modern forms, loading states, error dialogs, consistent theme.
- Code Quality: Lints enabled (`analysis_options.yaml` with `flutter_lints`), singleton services, navigation service, error handling.
- Testing: Widget smoke test updated to assert Splash renders.
- Documentation: Setup instructions, web configuration notes, architecture overview.

If your course rubric includes additional items (e.g., CRUD beyond user profiles, accessibility, localization, CI), let us know and we’ll extend this implementation accordingly.

## Setup
1) Install Flutter and Dart SDK (stable channel).
2) Install dependencies:
```
flutter pub get
```
3) Run on mobile/desktop (Firebase works out-of-the-box on these if configured in native projects):
```
flutter run
```

## Firebase Configuration
The app initializes Firebase using explicit options via `firebase_options.dart`.

Generate this file with FlutterFire CLI (no Google Sign-In required):
```
dart pub global activate flutterfire_cli
"%LOCALAPPDATA%\Pub\Cache\bin\flutterfire.bat" configure --platforms android --android-package-name com.example.kaontaproject
```
After generation:
```
flutter pub get
flutter run
```

## Project Structure (Highlights)
- `lib/main.dart`: App entry (`KarinderiaApp`), routes, theme.
- `lib/screens/splash_screen.dart`: Splash + navigation logic.
- `lib/screens/auth/`: Login/Signup/User Type/Social login screens.
- `lib/services/auth_service.dart`: Auth singleton, Firebase + Firestore integration, platform guards.
- `lib/repositories/user_repository.dart`: Firestore CRUD for users.
- `lib/models/user_model.dart`: User model with (de)serialization.
- `lib/routes/`: Route names and navigation service.

## Testing
Run analyzer and tests:
```
flutter analyze
flutter test
```
The default widget test was updated to verify Splash renders correctly with `KarinderiaApp`.

## Notes
- No Google Sign-In: The system uses mobile + password only. Ensure your Firebase project is created and `firebase_options.dart` is generated as shown above.

## License
For academic use per course requirements.
