# Mobile Spec Editor

A Flutter-based mobile application designed for developers to write "spec for spec coding" with ease. This markdown editor enhances productivity with powerful autocomplete features for custom commands (`/`) and file paths from configured GitHub repositories (`@`).

## Features

- **Markdown Editor:** A simple, full-screen editor for writing specs in markdown.
- **Auto-Saving:** Your work is automatically saved to your device as you type, so you never lose your progress.
- **Customizable `/` Commands:**
    - Define your own shorthand commands (e.g., `/bug`).
    - Add, edit, and delete commands in the settings.
    - Autocomplete suggestions appear as you type.
- **GitHub Integration for `@` Commands:**
    - Securely add multiple GitHub repositories using a URL (`owner/repo`) and a Personal Access Token (PAT).
    - Optionally provide a custom name for each repository for easier identification.
    - Get autocomplete suggestions for file paths within your repositories.
    - Cached file lists for offline access and faster performance.
    - Manually refresh the file list for any repository to keep it up-to-date.
- **State Management:** Uses `provider` for efficient and scalable state management.
- **Local Storage:** Leverages `shared_preferences` to persist settings and editor content.
- **GitHub API:** Integrates with the GitHub API using the `http` package to fetch repository file lists.

## Technology Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** `provider`
- **Local Storage:** `shared_preferences`
- **API Communication:** `http`

## Getting Started

To get the project up and running on your local machine:

1.  **Clone the repository:**
    ```bash
    git clone [repository_url]
    cd myapp
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

## Usage

- **Writing Specs:** Open the app and start writing in the main editor.
- **Using `/` Commands:** Type `/` to trigger the autocomplete overlay and see a list of your custom commands. Continue typing to filter the list.
- **Using `@` Commands:** Type `@` to get file path suggestions from your configured GitHub repositories.
- **Managing Settings:**
    - Tap the settings icon in the app bar to navigate to the settings screen.
    - In settings, you can:
        - Add, edit, or delete your custom `/` commands.
        - Navigate to the GitHub repository management screen.
- **Managing GitHub Repositories:**
    - From the settings screen, go to the GitHub repositories section.
    - Here you can:
        - Add a new repository with its URL and PAT, and an optional custom name.
        - Edit or delete existing repositories.
        - Manually trigger a refresh to fetch the latest file list for a repository.
