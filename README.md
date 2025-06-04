
# 📱 Flutter User Management App

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![BLoC](https://img.shields.io/badge/BLoC-%23FBBF24?style=flat&logo=githubactions&logoColor=black)](https://bloclibrary.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)]()
[![License](https://img.shields.io/badge/License-MIT-blue)]()

> A clean and modular Flutter app demonstrating user management using BLoC, REST API, offline caching, infinite scroll, and dynamic themes.

---

## 🚀 Features

### ✅ Core Functionality
- 🔄 DummyJSON API integration
- 🔍 Real-time search
- ⬇️ Infinite scrolling with pagination
- 👤 User detail with Posts & Todos
- 📝 Local post creation with preview
- 📟 BLoC state management
- ⚠️ Error & loading handling

### 💎 Bonus Features
- 🔄 Pull-to-refresh
- 🌓 Light/Dark theme toggle
- 💾 Offline user caching with `SharedPreferences`

---

## 📂 Project Structure

```
lib/
├── app/                  # App initialization and themes
├── core/                 # Constants, network, errors, utils
├── data/                 # API services, models, repositories
├── presentation/         # UI, BLoC, widgets
└── injection_container.dart  # DI with get_it
```

---

## 🏛️ Architecture

The app follows **Clean Architecture**:
- **Data Layer**: API/Local storage, repositories
- **Domain Layer**: Repository abstractions
- **Presentation Layer**: UI + BLoC (events, states)

Each feature (Users, Posts, Todos) has a dedicated BLoC and model set for separation of concerns.

---

## 🧱 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  http: ^1.1.0
  get_it: ^7.6.4
  cached_network_image: ^3.3.0
  shared_preferences: ^2.2.2
  connectivity_plus: ^5.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

---

## 🔧 Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/flutter-user-management-app.git
   cd flutter-user-management-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

> Ensure you have Flutter SDK installed. Recommended version: Flutter 3.19 or higher.

---

## 🌐 API Reference

- 👥 Users: `https://dummyjson.com/users`
- 📝 Posts: `https://dummyjson.com/posts/user/{userId}`
- ✅ Todos: `https://dummyjson.com/todos/user/{userId}`

> Full API Docs: [https://dummyjson.com/docs](https://dummyjson.com/docs)

---

## 📸 Screenshots

> *(Add `.png` or `.gif` screenshots here)*

---

## 🗃️ Folder Highlights

- `presentation/blocs/`: Contains user, post, todo, theme blocs
- `data/repositories/`: Interfaces + Implementations for API/Local data
- `core/`: API client, exceptions, constants, and utils

