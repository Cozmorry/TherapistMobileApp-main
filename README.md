# TheraPair Flutter Application

TheraPair is a comprehensive Flutter application designed to connect clients with therapists through a tailored pairing service. The app features a robust multi-role system, specialized onboarding flows, and integrated session management.

## Project Structure

The application is organized into a clean modular structure:

- **`lib/main.dart`**: Entry point that initializes Firebase, local storage, and notifications. It uses an `AuthWrapper` to handle routing based on authentication state and user roles.
- **`lib/models/`**: Data structures, including `UserModel.dart`.
- **`lib/services/`**: Core business logic:
    - `AuthService`: Handles Firebase Authentication and Google Sign-in.
    - `LocalStorageService`: Manages local data persistence.
    - `NotificationService`: Handles app notifications and permissions.
    - `TherapistMatchingService`: Logic for pairing clients with therapists.
- **`lib/widgets/`**: Reusable UI components like `MainLayout` and `PersistentNavBar`.

## Features & Pages

### Authentication & Onboarding
- **Login Page (`login_page.dart`)**: A unified interface for signing in or creating a new account using email/password or Google Sign-In.
- **Role Selection (`role_selection_page.dart`)**: Allows new users to choose between becoming a **Client** or a **Therapist**.
- **Client Onboarding (`client_onboarding_page.dart`)**: Collects preferences and medical history to better match clients with therapists.
- **Therapist Onboarding (`therapist_onboarding_page.dart`)**: Allows therapists to set up their specialties, approach, and availability.

### Client Experience
- **Home Page (`home_page.dart`)**: Dashboard for clients to search for therapists and view quick actions.
- **Search Results (`therapist_search_results_page.dart`)**: Displays matched therapists based on client needs.
- **Booking (`booking_page.dart`)**: Seamless flow for scheduling therapy sessions.
- **Sessions (`sessions_page.dart`)**: Overview of upcoming and past therapy appointments.
- **Resources (`resources_page.dart` & `article_detail_page.dart`)**: A library of articles and educational content.

### Therapist Experience
- **Therapist Home (`therapist_home_page.dart`)**: Specialized dashboard for therapists to manage their practice.
- **Booking Requests (`booking_requests_page.dart`)**: Interface to review and accept/decline new session requests.
- **Schedule Management (`session_schedule_page.dart`)**: Tools for therapists to manage their availability and calendar.
- **Therapist Sessions (`therapist_sessions_page.dart`)**: Detailed management of therapist-specific session logs.

### Shared Features
- **Notification Center (`notification_center_page.dart`)**: Central hub for all alerts and updates.
- **Feedback System (`feedback_page.dart` & `therapist_feedback_page.dart`)**: Tools for both parties to provide and review feedback.
- **Settings (`settings_page.dart`)**: Manage profile information and app preferences.

## Getting Started

To run this Flutter application:

1.  **Prerequisites**: Ensure you have [Flutter installed](https://docs.flutter.dev/get-started/install).
2.  **Dependencies**: Run `flutter pub get` in the project root.
3.  **Firebase Setup**: Ensure your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) are correctly configured for the Firebase project.
4.  **Run**: Connect a device or emulator and run `flutter run`.

## Technologies Used
- **Flutter & Dart**: Cross-platform UI development.
- **Firebase**: Authentication and backend services.
- **Local Storage**: For persistent user data and app state.
- **Material 3**: Modern UI design system.
