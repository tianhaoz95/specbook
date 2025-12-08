# Privacy Notice for Mobile Spec Editor

Last updated: December 7, 2025

Thank you for using Mobile Spec Editor. This privacy notice explains how our application collects, uses, and protects your information.

## Information We Collect

Mobile Spec Editor is designed to be a private and secure tool for developers. All data you create and use within the app is stored locally on your device. We do not collect or transmit any of your personal data to our servers or any third-party services, with the exception of the GitHub API as described below.

The information we handle includes:

-   **Editor Content:** The markdown text you write in the editor is saved locally on your device using `shared_preferences`. This data is not transmitted anywhere.
-   **Custom Commands:** Your custom `/` commands, including their titles and descriptions, are stored locally on your device using `shared_preferences`.
-   **GitHub Repository Information:**
    -   **Repository URL, Personal Access Token (PAT), and Optional Name:** To provide file path suggestions, you can configure GitHub repositories. This information is stored securely on your device and is not shared with us.
    -   **Cached File Lists:** For performance and offline access, the list of file paths from your repositories is cached and stored locally on your device.

## How We Use Your Information

The information collected is used solely to provide and improve the functionality of the app:

-   **Editor Content:** To save and restore your work between sessions.
-   **Custom Commands:** To provide autocomplete suggestions when you type `/`.
-   **GitHub Repository Information:** To provide autocomplete suggestions for file paths when you type `@`. The Personal Access Token (PAT) is used exclusively to make API calls to the GitHub API on your behalf to fetch the file list from your private or public repositories.

## Data Storage and Security

All your data is stored locally on your device using the standard application storage provided by your mobile operating system. We do not have access to this data.

## Third-Party Services

The only third-party service the app interacts with is the **GitHub API**. This interaction is initiated by you and uses your Personal Access Token (PAT) to fetch file lists from your configured repositories. We do not see, collect, or store your GitHub data on our servers. Your use of the GitHub API is subject to GitHub's privacy policy.

## Changes to This Privacy Notice

We may update this privacy notice from time to time. We will notify you of any changes by posting the new privacy notice in the app.

## Contact Us

If you have any questions about this privacy notice, you can contact us. (Note: A contact method should be provided here, but since this is a local app, this might not be necessary).
