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

## Local environment and publishing

This repository includes a local `.env` file for convenience (not tracked if
you follow the `.gitignore`). Do NOT commit `.env` or any secret keys.

Recommended workflow for publishing to GitHub:

- Keep `.env` in your local development environment and add `.env` to
	`.gitignore` (already done).
- Create `.env.example` with placeholder values (safe to commit) so others
	know which keys are required.
- Do NOT commit `firebase_options.dart` or secret files unless they are
	intentionally public. Instead prefer using CI secrets and generating
	configuration with the FlutterFire CLI during your build pipeline.

For GitHub Actions or other CI, store keys as repository secrets and inject
them into the build environment rather than committing them to the repo.

If you prefer to avoid committing `lib/firebase_options.dart`, use the
provided `lib/firebase_options.example.dart` as a template and keep the real
`lib/firebase_options.dart` out of version control. To stop tracking the
generated file locally run the following commands:

```powershell
git rm --cached lib/firebase_options.dart
echo "lib/firebase_options.dart" >> .gitignore
git add .gitignore
git commit -m "Stop tracking generated firebase_options.dart and ignore it"
git push
```

If `lib/firebase_options.dart` has already been pushed and you want to remove
it from the remote history completely, ask and I will provide safe steps (this
rewrites history and requires coordination).
