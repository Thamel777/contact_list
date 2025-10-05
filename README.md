# contact_list

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firebase setup

This app uses Firestore (`cloud_firestore`) and `firebase_core`. To run the
app you must configure Firebase for each platform (Android, iOS, web, etc.).

- Option A (recommended): use the FlutterFire CLI to configure your platforms:
	1. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
 2. Run `flutterfire configure` in the project root and follow prompts.

- Option B: add platform files manually:
	- Android: add `google-services.json` to `android/app/` and update Gradle.
	- iOS/macOS: add `GoogleService-Info.plist` to the Runner target.

After configuration, run `flutter run` on your target device. The app will
initialize Firebase at startup. If you don't configure Firebase, the app may
fail to initialize or throw runtime errors when attempting to access
Firestore.
