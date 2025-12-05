# Mobile Spec Editor Application Design

## 1. Overview

This document outlines the design for a mobile application aimed at helping developers write "spec for spec coding" on the go. The application will function as a markdown editor with enhanced autocomplete features for predefined commands ("/") and filenames from specified GitHub repositories ("@"). The primary goal is to enable efficient spec writing in a mobile environment, with output easily transferable to AI coding tools.

## 2. Detailed Analysis of the Goal/Problem

Developers often need to capture ideas and specifications quickly, even when not at a full workstation. Current mobile markdown editors lack the specialized autocomplete features required for "spec for spec coding," which typically involves referencing commands and files. This application addresses this by providing a focused environment with intelligent autocompletion, reducing typing effort and ensuring consistency with existing project structures.

## 3. Alternatives Considered

During the information gathering phase, several alternatives were considered and decided upon through user interaction:

*   **"/" Command Management:** A settings screen was chosen over a configuration file for user-friendliness and direct in-app management.
*   **GitHub Authentication:** A GitHub Personal Access Token (PAT) was selected as the initial authentication method due to its simplicity for implementation and deployment in a mobile context, as opposed to a more complex OAuth flow.
*   **GitHub Repository Handling:** A caching mechanism for repository file lists with a manual refresh option was chosen to optimize performance and data usage, avoiding constant API calls for large repositories.
*   **UI Layout:** A minimalist, full-screen editor with a dedicated settings access point was preferred to maximize screen real estate for writing.
*   **Data Persistence:** Local device storage was selected for both markdown content and user settings for ease of access and offline capability.

## 4. Detailed Design for the Modification

### 4.1. Application Architecture

The application will follow a standard Flutter architecture, separating concerns into presentation, domain, and data layers. State management will primarily utilize Flutter's built-in solutions (e.g., `ChangeNotifier`, `ValueNotifier`) and `provider` for app-wide state and dependency injection.

*   **Presentation Layer:** Widgets, Screens (Editor Screen, Settings Screen).
*   **Domain Layer:** Business logic for autocompletion, data models (e.g., `Command`, `GitHubRepo`).
*   **Data Layer:** Repositories for local storage, GitHub API client.

### 4.2. UI/UX Design

#### 4.2.1. Main Screen (Markdown Editor)

*   **Layout:** A full-screen `TextField` or `TextFormField` widget will serve as the markdown editor.
*   **Actions:** A single, prominent `IconButton` (e.g., a gear icon) in the `AppBar` will provide access to the settings screen.
*   **Responsiveness:** The layout will be responsive to different screen sizes and orientations.

#### 4.2.2. Settings Screen

*   **Sections:** The settings screen will be organized into logical sections:
    *   **"/" Commands Management:** A list of user-defined commands, with options to add, edit, and delete. Each command will have an associated description.
    *   **GitHub Repositories Management:** A list of configured GitHub repositories. Each entry will include:
        *   Repository URL (e.g., `owner/repo`).
        *   An input field for the GitHub Personal Access Token.
        *   A "Refresh" button to re-fetch and cache the file list.
        *   Options to add, edit, and delete repositories.
*   **Validation:** Input fields will include validation (e.g., valid URL format for repositories, token format).

#### 4.2.3. Autocomplete Display

*   **Mechanism:** Autocomplete suggestions will appear as an overlay (e.g., a modal bottom sheet or a custom overlay widget) positioned directly above the soft keyboard.
*   **Interaction:** Tapping on a suggestion will insert the selected text into the editor.

### 4.3. Feature: Markdown Editor

*   A standard Flutter `TextField` or `TextFormField` will be used.
*   Basic markdown syntax highlighting is a stretch goal, but not a core requirement for the initial version. The focus is on functionality.

### 4.4. Feature: "/" Command Autocomplete

*   **Trigger:** Typing `/` will activate the autocomplete.
*   **Data Source:** The app will retrieve the list of custom "/" commands from local storage (managed via the settings screen).
*   **Display:** Suggestions will be filtered as the user types after `/` and presented in the autocomplete overlay.

### 4.5. Feature: "@" Command Autocomplete (GitHub Integration)

*   **Trigger:** Typing `@` will activate the autocomplete.
*   **Authentication:** Uses a GitHub Personal Access Token (PAT) provided by the user in the settings. This token will be stored securely in local storage.
*   **Data Source:**
    *   When a GitHub repository is added or refreshed in settings, the app will use the GitHub API to fetch a list of all files within that repository.
    *   This file list will be stored locally on the device (e.g., using `shared_preferences` or `hive` for structured data).
    *   For monorepos, the user can add multiple GitHub repositories. The autocomplete will search across all cached file lists.
*   **Caching Strategy:**
    *   The file list for each configured repository will be cached locally.
    *   A "Refresh" button in the settings will trigger a re-fetch of the file list for a specific repository.
*   **Display:** Suggestions will be filtered as the user types after `@` and presented in the autocomplete overlay. The displayed text will be the filename, but the inserted text could be a relative path, depending on user preference (clarification needed during implementation, but for now, assume filename).

### 4.6. Data Persistence

*   **Local Storage:** The `shared_preferences` package will be used for simple key-value storage of user settings (e.g., PAT, "/" commands list). For more complex structured data like cached GitHub file lists, `hive` or `sembast` will be considered for better performance and scalability compared to `shared_preferences`.
*   **Markdown Content:** The current markdown content will be saved automatically to local storage periodically and on app exit.

## 5. Diagrams

### 5.1. High-Level Application Flow

```mermaid
graph TD
    A[Start App] --> B{User Input};
    B -- Type Markdown --> C[Editor Display];
    B -- Type "/" --> D{"/" Autocomplete Triggered};
    D --> E[Filter "/" Commands];
    E --> F[Display Suggestions];
    F --> G{User Selects};
    G -- Selected Command --> C;
    B -- Type "@" --> H{"@" Autocomplete Triggered};
    H --> I[Filter GitHub Filenames];
    I --> J[Display Suggestions];
    J --> K{User Selects};
    K -- Selected Filename --> C;
    C -- Periodically/On Exit --> L[Save Content Locally];
    M[Settings Screen] -- Configure Commands/Repos --> N[Save Settings Locally];
    N -- Add/Update Repo --> O[Fetch & Cache GitHub Files];
```

### 5.2. Settings Screen Interaction

```mermaid
graph TD
    A[Settings Screen] --> B{Choose Section};
    B -- "/ Commands" --> C[List "/ Commands"];
    C --> D[Add/Edit/Delete Command];
    D -- Save --> C;
    B -- "GitHub Repositories" --> E[List GitHub Repositories];
    E --> F[Add/Edit/Delete Repo];
    F --> G[Input Repo URL & PAT];
    G -- Save --> E;
    E -- "Refresh Button" --> H[Fetch & Cache Files for Repo];
    H -- Success --> E;
    H -- Error --> I[Display Error Message];
```

## 6. Summary of Design

The mobile spec editor will provide a streamlined markdown editing experience with intelligent autocompletion for user-defined commands and GitHub repository filenames. It leverages local storage for persistence and caching to ensure responsiveness. The design prioritizes a clean UI and efficient data handling, making it a practical tool for developers on the go.

## 7. References

No external research URLs were used for this design document as the design was derived interactively through user prompts and feedback.
