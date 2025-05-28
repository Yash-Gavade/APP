# FitVenture

A fitness adventure app with AR features and gamification. Discover hidden fitness challenges in your area and earn rewards!

## Features

- 🎯 AR-based surprise discovery
- 🗺️ Location-based challenges
- 🏆 Gamification with XP, levels, and badges
- 🌍 Multi-language support (English & German)
- 🎨 Beautiful UI with animations
- 🔐 Secure authentication
- 📱 Cross-platform (iOS & Android)

## Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode
- Google Maps API Key
- Firebase Project

## Setup

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
   - Add Android and iOS apps
   - Download and add the configuration files:
     - Android: `google-services.json` to `android/app/`
     - iOS: `GoogleService-Info.plist` to `ios/Runner/`

4. Configure Google Maps:
   - Get a Google Maps API key
   - Android: Add to `android/app/src/main/AndroidManifest.xml`
   - iOS: Add to `ios/Runner/AppDelegate.swift`

5. Create required assets:
   ```
   assets/
   ├── animations/
   │   └── loading.json
   ├── images/
   ├── models/
   │   └── surprise.glb
   └── icons/
   ```

6. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── l10n/              # Localization
├── models/            # Data models
├── screens/           # UI screens
├── services/          # Business logic
├── utils/             # Utilities
└── widgets/           # Reusable widgets
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- ARCore team for AR capabilities
- Google Maps team for location services
- All contributors and supporters