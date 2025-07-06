# Gemini Project Context: Scalable Flutter E-commerce App

This file summarizes the project context for the Gemini CLI agent.

## Project Overview

- **Application Type:** Scalable Flutter E-commerce Application.
- **Platform:** Cross-platform (iOS, Android, Web).
- **Architecture:** Feature-based, with a clear separation of concerns into `app`, `core`, and `features` directories.
- **State Management:** `flutter_bloc`.
- **Navigation:** `go_router`.
- **Backend:** Firebase (already configured by the user).
- **Dependencies:** A comprehensive list is available in `pubspec.yaml`, including `dio` for networking, `hive` for local storage, and `easy_localization` for internationalization.

## Current Goal

The immediate objective is to **integrate Google Sign-In** for user authentication.

- The user has confirmed that the necessary dependencies (`google_sign_in` and `firebase_auth`) have been added to the `pubspec.yaml` file.
- The next steps involve implementing the Google Sign-In logic within the `features/auth` module, likely creating a new use case, repository, and modifying the UI to include a "Sign in with Google" button.
