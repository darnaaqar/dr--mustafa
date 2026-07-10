<div align="center">
<img width="1200" height="475" alt="GHBanner" src="https://ai.google.dev/static/site-assets/images/share-ais-513315318.png" />
</div>

# Dr. Mustafa Dental Clinic App

A premium futuristic dental clinic mobile app built with Flutter. Features Arabic/English bilingual support, appointment booking, service showcase, and gallery.

## Features

- 📱 Modern UI with dark theme and neon accents
- 🌍 Arabic/English language toggle
- 📅 Appointment booking system
- 🛠️ Services showcase with beautiful cards
- 🖼️ Image gallery
- 👨‍⚕️ Doctor profile
- 📞 Contact information

## Getting Started

### Prerequisites
- Flutter SDK 3.24.x or higher
- Android SDK
- Java 17

### Running Locally

1. Navigate to the Flutter app directory:
   ```bash
   cd flutter_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Building APK

The project includes a GitHub Actions workflow that automatically builds the APK on push.

To build locally:
```bash
cd flutter_app
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

## GitHub Actions

Push to the `main` or `master` branch to trigger an automatic build. The APK artifact will be available in the Actions tab after the build completes.

## Supabase Configuration

The app uses Supabase for backend services. Configure your Supabase credentials in `lib/main.dart` or use environment variables. A fallback mode is available when Supabase is unavailable.

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart              # App entry point
│   ├── home_screen.dart       # Main screen with navigation
│   ├── constants.dart         # Color palette and translations
│   ├── database_service.dart  # Supabase integration
│   └── screens/
│       ├── services_screen.dart
│       ├── gallery_screen.dart
│       ├── about_screen.dart
│       └── contact_screen.dart
└── android/                   # Android native project