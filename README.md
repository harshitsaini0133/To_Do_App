# To Do APP

A polished Flutter to-do application with Firebase Authentication and Firebase Realtime Database integrated through REST APIs.

This project is built to feel like a premium productivity app while keeping the codebase structured, scalable, and easy to extend.

## What You Get

- Email/password sign up and login
- Persistent authenticated sessions
- Task create, read, update, delete
- Per-user task isolation in Firebase Realtime Database
- Pull-to-refresh and swipe-to-delete
- Animated task completion cards
- Custom add-task composer sheet
- Custom date and time picker
- Clean architecture style separation with Bloc state management

## Tech Stack

- Flutter
- `flutter_bloc`
- `dio`
- Firebase Authentication REST API
- Firebase Realtime Database REST API
- `flutter_secure_storage`
- `google_fonts`

## Important Note

This app uses Firebase over REST.

- `FIREBASE_API_KEY` is used for Firebase Authentication REST endpoints.
- Realtime Database requests use the signed-in user's Firebase ID token in the `auth` query parameter.
- `firebase_core` is not required for the current implementation.

If you already have `google-services.json` in `android/app/`, that is fine, but this app's runtime flow is currently based on REST configuration passed through `--dart-define`.

## Project Structure

```text
lib/
  app/
    app.dart
  core/
    animations/
    api/
    config/
    constants/
    theme/
    utils/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    tasks/
      data/
      domain/
      presentation/
  main.dart
```

## Main Screens

- Splash screen
- Login screen
- Register screen
- Dashboard
- Add task composer
- Edit task screen

## Prerequisites

Make sure you have:

- Flutter SDK installed
- A working Android emulator or physical device
- A Firebase project
- Firebase CLI if you want to deploy rules from the terminal

Check Flutter installation:

```bash
flutter doctor
```

## Quick Start

1. Get dependencies:

```bash
flutter pub get
```

2. Run the app with Firebase values:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=YOUR_FIREBASE_WEB_API_KEY \
  --dart-define=FIREBASE_DATABASE_URL=https://YOUR_PROJECT_ID-default-rtdb.firebaseio.com
```

Example with the current project values:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=AIzaSyBm3_iGwHRMIaFMj4H_aW5Zj2xX9UNR4uw \
  --dart-define=FIREBASE_DATABASE_URL=https://bookzila-3147b-default-rtdb.firebaseio.com
```

## Where Configuration Is Read

Runtime configuration is read from:

- `lib/core/config/app_config.dart`

The app expects these values:

- `FIREBASE_API_KEY`
- `FIREBASE_DATABASE_URL`

If either value is missing, API requests will fail with a configuration error.

## Firebase Setup

### 1. Create a Firebase Project

Create a project in Firebase Console.

### 2. Enable Email/Password Authentication

In Firebase Console:

`Authentication` -> `Sign-in method` -> enable `Email/Password`

### 3. Create a Realtime Database

In Firebase Console:

`Build` -> `Realtime Database` -> create database

Copy the database URL. It will look like:

```text
https://your-project-id-default-rtdb.firebaseio.com
```

### 4. Get the Web API Key

In Firebase Console:

`Project settings` -> `General` -> `Web API Key`

Use that value as `FIREBASE_API_KEY`.

### 5. Apply Realtime Database Rules

This project stores tasks under the signed-in user only, so rules must allow a user to read and write only their own path.

Rules used by this app:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "auth !== null && auth.uid === $uid",
        ".write": "auth !== null && auth.uid === $uid",
        "tasks": {
          ".indexOn": ["createdAt", "dueDate", "completed"]
        }
      }
    }
  }
}
```

These rules are already included in:

- `database.rules.json`

You can apply them in either of two ways.

Option 1: Firebase Console

- Open `Realtime Database`
- Go to `Rules`
- Paste the JSON above
- Publish

Option 2: Firebase CLI

```bash
firebase deploy --only database --project bookzila-3147b
```

## Database Shape

Tasks are stored per user in this structure:

```json
{
  "users": {
    "uid": {
      "tasks": {
        "taskId": {
          "title": "Ship polished dashboard",
          "description": "Refine animations and spacing",
          "createdAt": "2026-03-09T18:30:00.000Z",
          "dueDate": "2026-03-10T09:00:00.000Z",
          "completed": false
        }
      }
    }
  }
}
```

## How Authentication and Database Access Work

This part is important because many Firebase REST integrations fail here.

### Authentication

The app signs users in through Firebase Authentication REST endpoints.

Examples:

- `accounts:signInWithPassword`
- `accounts:signUp`
- token refresh endpoints

These requests use:

- `FIREBASE_API_KEY`

### Realtime Database

Database requests do not use the API key for authorization.

Instead, the app sends the Firebase Auth ID token from the signed-in session:

```text
.../users/{uid}/tasks.json?auth={idToken}
```

The task data source responsible for this is:

- `lib/features/tasks/data/datasources/tasks_remote_data_source.dart`

## Common Commands

### Run

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=YOUR_FIREBASE_WEB_API_KEY \
  --dart-define=FIREBASE_DATABASE_URL=https://YOUR_PROJECT_ID-default-rtdb.firebaseio.com
```

### Build APK

```bash
flutter build apk \
  --dart-define=FIREBASE_API_KEY=YOUR_FIREBASE_WEB_API_KEY \
  --dart-define=FIREBASE_DATABASE_URL=https://YOUR_PROJECT_ID-default-rtdb.firebaseio.com
```

### Analyze

```bash
flutter analyze
```

### Test

```bash
flutter test
```

## Troubleshooting

### 1. `Firebase is not configured`

Cause:

- `FIREBASE_API_KEY` or `FIREBASE_DATABASE_URL` was not passed with `--dart-define`

Fix:

Run the app again with both values.

### 2. `401 Unauthorized` or `Permission denied`

Cause:

- Realtime Database rules are missing or too strict
- The authenticated user's ID token is valid, but your database rules are rejecting the path

Fix:

- Apply the rules from `database.rules.json`
- Sign out and sign back in
- Retry loading or creating tasks

### 3. Authentication works but tasks do not load

Cause:

- Database URL is wrong
- Rules are not deployed
- The app is pointed to a different Firebase project than the one used for auth

Fix:

- Recheck `FIREBASE_DATABASE_URL`
- Confirm your Firebase project ID
- Confirm rules are published

### 4. `google-services.json` exists but app still needs `--dart-define`

Cause:

- This app is not currently initialized through Firebase SDK configuration

Fix:

- Keep using `--dart-define`
- Or refactor the project to use Firebase SDK instead of REST

## Architecture Notes

This codebase follows a practical clean-architecture split:

- `presentation`: UI, widgets, Bloc, pages
- `domain`: entities, repositories, use cases
- `data`: remote data sources, models, repository implementations

Two main state domains are separated:

- `AuthBloc`
- `TaskBloc`

## UI Notes

The app includes premium UI touches such as:

- gradient-driven visual system
- glass and layered surfaces
- animated task completion interaction
- custom task creation sheet
- custom date/time picker
- polished auth screens

## Current Verification Status

Latest local verification:

```bash
flutter analyze
flutter test
```

Both pass in the current workspace.

## Suggested Next Improvements

If you want to extend the app further, the next practical additions would be:

- Google Sign-In implementation
- search and task filters
- offline caching
- task categories or tags
- reminder notifications
- CI pipeline for analyze and test

## Repository Files Worth Knowing

- `lib/app/app.dart`
- `lib/core/config/app_config.dart`
- `lib/core/api/api_routes.dart`
- `lib/features/auth/presentation/bloc/auth_bloc.dart`
- `lib/features/tasks/presentation/bloc/task_bloc.dart`
- `lib/features/tasks/presentation/pages/dashboard_page.dart`
- `lib/features/tasks/presentation/widgets/add_task_sheet.dart`
- `lib/features/tasks/presentation/widgets/task_card.dart`
- `database.rules.json`
- `firebase.json`

## License

This project currently does not declare a license.
