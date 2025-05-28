# FitQuest - Gamified Fitness Assistant 🏃‍♂️

A gamified fitness assistant app that combines AI coaching, real-world challenges, and habit tracking to make fitness fun and engaging.

## 🌟 Features

- 🤖 AI-powered fitness coach with contextual conversations
- 🎮 Gamification elements (XP, badges, streaks)
- 🗺️ AR-based real-world challenges
- 📊 Mood and workout tracking
- 📝 Reflection journaling
- 🎯 Personalized workout plans
- 🔔 Smart reminders and motivation

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore)
- **AI**: OpenAI API / Rasa
- **Maps & AR**: Google Maps, ARKit/ARCore
- **Animations**: Rive/Lottie

## 📱 App Structure

```
lib/
├── main.dart                 # Entry point
├── screens/                  # UI screens
├── widgets/                  # Reusable components
├── services/                 # Business logic
├── models/                   # Data models
└── utils/                    # Utilities
```

## 🚀 Getting Started

1. Install Flutter (latest stable version)
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Configure Firebase project and add credentials
5. Set up OpenAI API key in environment variables
6. Run `flutter run` to start the app

## 🔧 Environment Setup

Create a `.env` file in the root directory with:

```
OPENAI_API_KEY=your_api_key_here
FIREBASE_CONFIG=your_firebase_config_here
```

## 📋 Development Roadmap

- [x] Project setup and structure
- [ ] Core UI implementation
- [ ] Firebase integration
- [ ] AI chatbot implementation
- [ ] Workout plan generator
- [ ] Gamification system
- [ ] AR challenges
- [ ] Testing and optimization

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by Duolingo's gamification
- AR challenges inspired by Pokémon Go
- AI coaching concepts from various fitness apps