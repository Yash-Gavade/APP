# FitVenture - Gamified Fitness App

FitVenture is a gamified fitness app that makes working out fun and engaging, similar to Duolingo and Pokémon GO. The app combines fitness tracking, social features, and augmented reality to create an immersive fitness experience.

## Features

- 🎮 Gamified workout experience
- 👥 Social features (friends, groups, challenges)
- 🎯 AR-based surprise discoveries
- 📊 Progress tracking and achievements
- 🏆 Badges and rewards system
- 🌍 Multi-language support
- 🌙 Dark/Light theme
- 📱 Responsive design

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)
- Firebase account

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/fitventure.git
cd fitventure
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files:
     - Android: `google-services.json` to `android/app/`
     - iOS: `GoogleService-Info.plist` to `ios/Runner/`

4. Update Firebase configuration:
   - For Android: Update `android/app/build.gradle` with your Firebase configuration
   - For iOS: Update `ios/Runner/Info.plist` with your Firebase configuration

5. Generate assets:
```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

### Running the App

1. Connect a device or start an emulator

2. Run the app:
```bash
flutter run
```

### Testing Credentials

For testing purposes, you can use the following admin account:
- Email: admin@fitventure.com
- Password: 1234

## Project Structure

```
lib/
├── l10n/                 # Localization files
├── models/              # Data models
├── screens/             # App screens
│   ├── auth/           # Authentication screens
│   ├── home/           # Home screen and related
│   ├── profile/        # Profile screens
│   ├── settings/       # Settings screens
│   ├── social/         # Social features
│   └── surprise/       # AR discovery features
├── services/           # Business logic and services
├── utils/              # Utility functions and constants
├── widgets/            # Reusable widgets
└── main.dart           # App entry point
```

## Development

### Code Style

The project follows the official Flutter style guide. Run the following command to check your code:

```bash
flutter analyze
```

### Building for Release

1. Android:
```bash
flutter build apk --release
```

2. iOS:
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors and supporters of the project