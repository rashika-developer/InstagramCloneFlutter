# Instagram Feed Clone — Flutter

A pixel-perfect replication of the Instagram Home Feed, built as a Flutter UI/UX challenge.

---

## 📸 Features

| Feature | Details |
|---|---|
| **Shimmer Loading** | Skeleton screens on initial load (not spinners) |
| **Stories Tray** | Horizontal scroll with gradient ring, "Your Story" tile |
| **Post Feed** | Avatar, location, image, actions, caption, timestamp |
| **Carousel Posts** | Horizontal swipe with dot indicator + page counter |
| **Pinch-to-Zoom** | Scale image over UI, spring-animates back on release |
| **Double-tap Like** | Floating heart animation, red heart toggle |
| **Like / Save Toggle** | Stateful, persists during session |
| **Infinite Scroll** | Fetches next 10 posts when 2 posts from the bottom |
| **Pull-to-Refresh** | Reloads feed and stories |
| **Snackbars** | Unimplemented buttons show a dismissible snackbar |
| **Error Handling** | Broken image placeholder for failed network images |

---

## 🏗️ Architecture

```
lib/
├── main.dart                  # App entry point
├── models/
│   ├── post_model.dart        # Post data model
│   └── story_model.dart       # Story data model
├── services/
│   └── post_repository.dart   # Mock data + 1.5s simulated latency
├── providers/
│   └── feed_provider.dart     # Riverpod state (FeedNotifier, stories)
├── widgets/
│   ├── shimmer_feed.dart      # Skeleton loading UI
│   ├── story_tray.dart        # Horizontal stories row
│   ├── post_card.dart         # Full post component
│   ├── carousel_widget.dart   # Multi-image swiper with dots
│   └── pinch_zoom_overlay.dart # Pinch-to-zoom gesture handler
└── screens/
    └── home_screen.dart       # Main screen, scroll controller, top bar
```

### State Management: Riverpod

Riverpod was chosen because:
- It's compile-safe (no runtime `context.watch` mistakes)
- `StateNotifier` gives clean separation of state and logic
- `FutureProvider` handles async data (stories) elegantly
- Easy to test in isolation

---

## 🚀 How to Run

### Prerequisites

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Verify installation:
   ```bash
   flutter doctor
   ```

### Steps

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/instagram_clone.git
cd instagram_clone

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run
```

### Running on iOS Simulator
```bash
open -a Simulator
flutter run
```

### Running on Android Emulator
```bash
# Start emulator first from Android Studio, then:
flutter run
```

### Build a release APK
```bash
flutter build apk --release
# APK will be at: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 Dependencies

```yaml
flutter_riverpod: ^2.5.1      # State management
cached_network_image: ^3.3.1  # Image caching (memory + disk)
shimmer: ^3.0.0               # Skeleton loading animations
```

---

## 🎬 Demo

> Screen recording showing:
> - Shimmer loading state on launch
> - Smooth infinite scroll with pagination loader
> - Pinch-to-zoom with spring-back animation
> - Like/Save toggle interactions
> - Carousel swipe with dot indicators
> - Snackbars on unimplemented buttons

---

## ⚠️ Notes

- Images are loaded from public Unsplash URLs (no bundled assets)
- All data is mocked — `PostRepository` simulates a 1.5s network delay
- Feed stops at page 10 (100 posts) and shows "You're all caught up 🎉"
