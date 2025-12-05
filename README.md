# Mobile Spec Editor

A mobile application designed to help developers write "spec for spec coding" on the go. This markdown editor provides enhanced autocomplete features for custom commands (`/`) and filenames from specified GitHub repositories (`@`). The goal is to streamline the spec writing process, allowing for easy transfer of generated specs to AI coding tools.

## Features

- **Markdown Editor:** A full-screen text editor supporting markdown syntax.
- **Customizable `/` Commands:** Users can define, edit, and delete custom commands for quick insertion via an autocomplete mechanism.
- **GitHub Integration for `@` Commands:**
    - Configure multiple GitHub repositories with Personal Access Tokens (PATs).
    - Autocompletion for filenames from the specified repositories.
    - Local caching of repository file lists for offline access and improved performance.
    - Manual refresh option to update cached file lists.
- **Auto-Saving:** Editor content is automatically saved to local storage, ensuring data persistence across sessions.
- **Intuitive UI:** A clean, minimalist interface focused on the writing experience, with easy access to settings.

## Getting Started

To run this project:

1.  **Clone the repository:**
    ```bash
    git clone [repository_url]
    cd mobile-spec-editor
    ```
2.  **Get dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

## Usage

- **Editor Screen:** Start writing your spec.
- **`/` Autocomplete:** Type `/` to see suggestions for custom commands.
- **`@` Autocomplete:** Type `@` to see suggestions for filenames from configured GitHub repositories.
- **Settings:** Access the settings screen via the gear icon in the app bar to manage your custom commands and GitHub repositories.