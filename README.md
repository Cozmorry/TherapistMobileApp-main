# TheraPair Flutter Application

This project is a Flutter application for a therapy pairing service, `TheraPair`.
It currently features a multi-page user flow for initial onboarding and registration.

## Project Structure

The main application entry point is `lib/main.dart`.

## Pages Implemented

### 1. Welcome Page (`lib/welcome_page.dart`)
This is the initial screen users see when launching the application. It displays:
- The `TheraPair` logo (represented by a heart icon with two person icons).
- The application name: "TheraPair".
- A tagline: "Tailoring therapy to your needs".
- A "Get Started" button that navigates to the `SelectRolePage`.

### 2. Select Role Page (`lib/select_role_page.dart`)
This page allows users to choose their role within the application. It features:
- A title: "Select Your Role".
- Two main buttons:
    - "Client": Navigates to the `ClientRegistrationPage`.
    - "Therapist": Navigates to the `TherapistRegistrationPage`.

### 3. Client Registration Page (`lib/client_registration_page.dart`)
This page is for new clients to register their account. It includes:
- A "Register" title.
- Input fields for:
    - Username
    - Email
    - Password
    - Relevant Medical History (Optional - multi-line input).
- A "Register" button.
- A "Already have an account? Log In" section with a clickable "Log In" text.

### 4. Therapist Registration Page (`lib/therapist_registration_page.dart`)
This page is for therapists to register their account. It includes:
- A "Register" title.
- Input fields for:
    - Username
    - Email
    - Password
    - Indicate specialties, approaches and availability (multi-line input).
- A "Register" button.
- A "Already have an account? Log In" section with a clickable "Log In" text.

## Getting Started

To run this Flutter application:

1.  Ensure you have Flutter installed. If not, follow the official installation guide:
    [Install Flutter](https://docs.flutter.dev/get-started/install)
2.  Clone this repository to your local machine.
3.  Navigate to the project directory in your terminal.
4.  Run `flutter pub get` to fetch all dependencies.
5.  Connect a device or start an emulator.
6.  Run the application using `flutter run`.

## Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter online documentation](https://docs.flutter.dev/)
