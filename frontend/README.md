
# Quantum Wallet App (Flutter)

## Quickstart
```bash
flutter pub get
# If android/ios/web folders are missing:
flutter create .
flutter run
```


## Firebase OTP Login
- The app includes a simple **phone number OTP** login screen.
- Initialize Firebase either with default native config (Android/iOS) or via `DefaultFirebaseOptions` (add your own `firebase_options.dart` if you use FlutterFire CLI).
- After login, the app saves the ID token to `SharedPreferences('firebase_id_token')` which the API client attaches as `Authorization: Bearer <token>`.

### Minimal setup tips
- Android: add `google-services.json` and Gradle plugin if you want native config.
- Or run without native config if your backend does not strictly require JWT yet; you can bypass login for demos by pre-setting the token in preferences.


## New features
- **Settings screen**: sign out + language selection (Yorùbá / Hausa / Pidgin). Language requires app restart to apply (lightweight approach).
- **Wallet picker** on Send screen: select which wallet to debit.
- **Pull-to-refresh** on Recent Transactions list.
