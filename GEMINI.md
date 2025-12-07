# AI Development Guidelines for Flutter in Firebase Studio

## Environment & Context Awareness

The AI operates within the Firebase Studio development environment. This application adheres to the standard Flutter project structure, with `lib/main.dart` as the entry point. The `.idx/dev.nix` and `mcp.json` configurations are respected for environment consistency.

## Application Overview: Mobile Spec Editor

This Flutter application is a mobile markdown editor designed for "spec for spec coding." It features:

- **Markdown Editing:** A core feature for writing specifications.
- **`/` Command Autocomplete:** User-defined commands are suggested when `/` is typed.
- **`@` Command Autocomplete (GitHub Integration):** Filenames from configured GitHub repositories are suggested when `@` is typed. This involves:
    - GitHub Personal Access Token (PAT) for authentication.
    - Local caching of repository file lists for performance.
- **Auto-Saving:** Content is automatically saved to local storage (`shared_preferences`).

## Code Modification & Dependency Management

The application uses the following key packages:

- `provider`: For state management (`SettingsService`, `GitHubService`).
- `shared_preferences`: For local persistence of settings (commands, GitHub repos, editor content).
- `http`: For making API calls to GitHub.

## Automated Error Detection & Remediation

- **Testing:** Comprehensive `widget_test.dart` covers UI rendering, `autocompletion` for both `/` and `@` commands, and auto-save/load functionality.
- **Linting & Formatting:** `dart_fix` and `dart_format` are used to maintain code quality and style.
- **Lifecycle Management:** Special attention has been paid to widget lifecycle (e.g., `mounted` checks in `EditorScreen`) to prevent errors like `_lifecycleState != _ElementLifecycle.defunct`.

## Material Design Specifics

- **Theming:** Uses default Material 3 theming.
- **UI Structure:** Follows a clean, minimalist design with `Scaffold`, `AppBar`, `TextField`, and `ListView` components. `AlertDialog` is used for adding/editing items in settings. `OverlayEntry` is used for autocomplete suggestions.

## Application Architecture

- **Widgets are the UI:** All UI components are built as Flutter widgets.
- **State Management:** `Provider` is used for app-wide state management, making `SettingsService` and `GitHubService` accessible. `StatefulWidget` (`EditorScreen`, `SettingsScreen`, `GitHubRepoSettingsScreen`) manage local UI state.
- **Separation of Concerns:** Logic is separated into `screens` (presentation), `models` (data structures), and `services` (business logic, data access).
- **Data Flow:** Data flows from services (local storage, GitHub API) to models, then managed by providers, and consumed by UI widgets.

## Android Release Process

After any bug fix or feature development, follow these steps to create and upload a new Android release to the Google Play Console:

1.  **Increment Build Number:**
    -   Open `pubspec.yaml`.
    -   Increase the build number (the number after the `+`). For example, change `version: 1.0.0+6` to `version: 1.0.0+7`.

2.  **Build the Android App Bundle (AAB):**
    -   Run the following command in your terminal:
        ```bash
        flutter build aab
        ```

3.  **Upload to Google Play Console:**
    -   Navigate to the `android` directory:
        ```bash
        cd android
        ```
    -   Run the `fastlane internal` lane to upload the build to the internal testing track:
        ```bash
        fastlane internal
        ```

### Publishing the Release on Google Play Console

After successfully uploading the AAB via `fastlane internal`, follow these manual steps to publish the release:

1.  **Access Google Play Console:**
    -   Go to the [Google Play Console](https://play.google.com/console).
    -   Navigate to your application, `SpecEditorGo`.

2.  **Edit the Release:**
    -   In the left-hand menu, go to `Testing` -> `Internal testing`.
    -   Locate and click on the "Edit release" button for the desired release.

3.  **Review and Save:**
    -   Review the release details on the subsequent pages, clicking "Next" to proceed through any sections (e.g., "Review release").
    -   Click the "Save and publish" button (or similar wording, as UI might change) located at the bottom right.

4.  **Confirm Publication:**
    -   A confirmation pop-up will appear. Confirm your action to publish the release to the internal testing track.
## Controlling Browser via Local-Server MCP

To control the browser and complete actions, utilize the local-server MCP (Multi-platform Control Protocol) integration. This allows for programmatic interaction with browser elements.