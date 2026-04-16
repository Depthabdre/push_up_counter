# 🏋️ PushUps

A beautifully designed, highly precise, and motivating Flutter application that uses your phone's built-in proximity sensor to automatically count your push-ups. 

Simply place your phone on the floor beneath your chest, hit start, and get to work. The app tracks your reps, gives you real-time audio hype, and logs your all-time high scores!

## ✨ Features
* **Hardware-Accurate Counting:** Uses the device proximity sensor with custom debouncing logic (150ms threshold) to guarantee zero false-reads or double-counts.
* **Modern & Joyful UI:** A vibrant Cyan glass-morphism aesthetic, featuring silky-smooth animations that react to your movement, glowing orbs, and a pristine dark-mode canvas.
* **Audio Coach:** Real-time text-to-speech counts your reps aloud, plays hype sounds (like the legendary "Yeah buddy!") every 10 reps, and encourages you if you pause mid-set.
* **High Score Tracking:** Keeps a persistent record of your personal bests and lifetime total reps.

## 🚀 How to Use
1. Open the app and tap **Start Workout**.
2. Place your device flat on the floor directly beneath your chest.
3. Lower yourself until your chest is near the screen. The app will visually glow and count when you push back up.
4. Complete your workout, tap **Finish Workout**, and check out your stats!

## 🛠️ Tech Stack
* **Framework:** Flutter & Dart
* **Architecture:** Clean Architecture + Core/Features distinction
* **State Management:** BLoC (`flutter_bloc`) + GetIt for Dependency Injection
* **Hardware Integration:** `proximity_sensor`
* **Audio & Haptics:** `audioplayers`, `flutter_tts`
* **Local Storage:** `shared_preferences`

## 🏗️ Getting Started
1. Ensure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. Clone this repository.
3. Run `flutter pub get` to install dependencies.
4. Connect a **physical device** (the iOS Simulator/Android Emulator does not support a proximity sensor natively) and hit `flutter run`.
