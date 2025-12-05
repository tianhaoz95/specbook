# Mobile Spec Editor - Implementation Plan

This document outlines the phased implementation plan for building the mobile spec editor application.

## Journal

*This section will be updated chronologically after each phase to log actions taken, learnings, surprises, and any deviations from the plan.*

**Phase 1 Completion (2025-12-05)**
- Ran initial tests, all passed.
- Added dependencies: `provider`, `shared_preferences`, `http`.
- Created UI structure: `EditorScreen`, `SettingsScreen`.
- Set up navigation between screens.
- Created data models: `Command`, `GitHubRepo`.
- Updated `widget_test.dart` to reflect UI changes.
- Ran `dart_fix`, `analyze_files`, `run_tests`, and `dart_format` with no issues.
- Committed changes: `feat: Initial UI shell and project setup`

**Phase 2 Completion (2025-12-05)**
- Implemented `SettingsService` for saving/loading "/" commands.
- Modified `Command` model for JSON serialization.
- Provided `SettingsService` via `Provider` in `main.dart`.
- Implemented UI in `SettingsScreen` for managing "/" commands (add, edit, delete).
- Implemented autocomplete logic in `EditorScreen` for "/" commands.
- Added a new test for "/" command autocomplete functionality.
- Fixed `use_build_context_synchronously` lint in `SettingsScreen`.
- Fixed `_lifecycleState != _ElementLifecycle.defunct` error in `EditorScreen` during dispose.
- All tests passing.
- Code formatted.
- Committed changes: `feat: Implement '/' command autocomplete and settings management`

**Phase 3 Completion (2025-12-05)**
- Modified `GitHubRepo` model for JSON serialization and added `cachedFiles` field.
- Updated `SettingsService` to save and load `GitHubRepo` objects.
- Created `GitHubService` to fetch repository files using GitHub API.
- Integrated `GitHubService` via `MultiProvider` in `main.dart`.
- Implemented `GitHubRepoSettingsScreen` for managing GitHub repositories (add, edit, delete).
- Implemented "Refresh" functionality in `GitHubRepoSettingsScreen` to fetch and cache repository files.
- Implemented autocomplete logic in `EditorScreen` for "@" commands using cached GitHub files.
- Added a new test for "@" command autocomplete functionality.
- Fixed various testing and UI rendering issues related to overlays and widget lifecycle.
- All tests passing.
- Code formatted.
- Committed changes: `feat: Implement '@' command autocomplete and GitHub integration`

**Phase 4 Completion (2025-12-05)**
- Implemented auto-saving and loading for markdown content in `editor_screen.dart` using `shared_preferences`.
- Resolved `RangeError` during content loading by temporarily removing and re-adding listener.
- Added a new test for auto-save/load functionality.
- All tests passing.
- Code formatted.

---

---

---

## Phase 1: Project Setup & Initial UI Shell

- [x] Run all tests to ensure the project is in a good state before starting modifications.
- [x] Add necessary dependencies to `pubspec.yaml`:
    - `provider` for state management.
    - `shared_preferences` for local storage.
    - `http` for making API calls to GitHub.
- [x] Create the basic UI structure:
    - `lib/screens/editor_screen.dart`: A stateful widget containing the main text area and the settings button.
    - `lib/screens/settings_screen.dart`: A placeholder stateful widget for the settings UI.
- [x] Set up navigation between the `EditorScreen` and `SettingsScreen`.
- [x] Create initial data models in `lib/models/`:
    - `command.dart`: A simple class for "/" commands (`title`, `description`).
    - `github_repo.dart`: A class for GitHub repository configurations (`url`, `pat`).
- [x] After completing the tasks in this phase:
    - [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
    - [x] Run the `dart_fix` tool to clean up the code.
    - [x] Run the `analyze_files` tool one more time and fix any issues.
    - [x] Run any tests to make sure they all pass.
    - [x] Run `dart_format` to make sure that the formatting is correct.
    - [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
    - [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
    - [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
    - [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
    - [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 2: "/" Command Implementation

- [x] Implement the UI in `settings_screen.dart` for adding, editing, and deleting "/" commands.
- [x] Implement a `SettingsService` that uses `shared_preferences` to save and load the list of "/" commands.
- [x] In `editor_screen.dart`, implement the logic to detect when the user types "/" and trigger the autocomplete UI.
- [x] Create an autocomplete widget that displays a filtered list of "/" commands from the `SettingsService`.
- [x] Implement the logic to insert the selected command into the editor.
- [x] After completing the tasks in this phase:
    - [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
    - [x] Run the `dart_fix` tool to clean up the code.
    - [x] Run the `analyze_files` tool one more time and fix any issues.
    - [x] Run any tests to make sure they all pass.
    - [x] Run `dart_format` to make sure that the formatting is correct.
    - [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
    - [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
    - [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
    - [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
    - [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 3: "@" Command (GitHub) Implementation

- [ ] Implement the UI in `settings_screen.dart` for adding, editing, and deleting GitHub repository configurations.
- [ ] Update the `SettingsService` to save and load the list of GitHub repositories.
- [ ] Create a `GitHubService` that uses the `http` package to fetch the file list for a given repository and PAT.
- [ ] Implement the caching mechanism within the `GitHubService` to store the file lists locally (using `shared_preferences` for simplicity in this phase).
- [ ] Implement the "Refresh" functionality in the settings screen to trigger the `GitHubService` to re-fetch and re-cache the file list.
- [ ] In `editor_screen.dart`, implement the logic to detect when the user types "@" and trigger the autocomplete UI.
- [ ] Update the autocomplete widget to display a filtered list of filenames from the cached data.
- [ ] Implement the logic to insert the selected filename into the editor.
- [ ] After completing the tasks in this phase:
    - [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
    - [ ] Run the `dart_fix` tool to clean up the code.
    - [ ] Run the `analyze_files` tool one more time and fix any issues.
    - [ ] Run any tests to make sure they all pass.
    - [ ] Run `dart_format` to make sure that the formatting is correct.
    - [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
    - [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
    - [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
    - [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
    - [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 4: Data Persistence & Finalization

- [ ] Implement auto-saving for the markdown content in `editor_screen.dart`.
- [ ] Load the saved markdown content when the app starts.
- [ ] Update the `README.md` file with a description of the app and its features.
- [ ] Update the `GEMINI.md` file to reflect the new application structure and implementation details.
- [ ] After completing the tasks in this phase:
    - [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
    - [ ] Run the `dart_fix` tool to clean up the code.
    - [ ] Run the `analyze_files` tool one more time and fix any issues.
    - [ ] Run any tests to make sure they all pass.
    - [ ] Run `dart_format` to make sure that the formatting is correct.
    - [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
    - [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
    - [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
    - [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
    - [ ] After committing the change, if an app is running, use the `hot_reload` tool to reload it.
- [ ] Ask the user to inspect the package (and running app, if any) and say if they are satisfied with it, or if any modifications are needed.
