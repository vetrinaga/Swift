# Development Environment Setup

This guide will help you set up the development environment for the GCC Car Hire mobile app.

## 📋 Prerequisites

### Required Software

1. **Flutter SDK** (3.10.0 or higher)
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Add Flutter to your PATH
   - Run `flutter doctor` to verify installation

2. **Dart SDK** (3.0.0 or higher)
   - Included with Flutter SDK
   - Verify with `dart --version`

3. **IDE/Editor**
   - **Android Studio** (recommended) with Flutter plugin
   - **VS Code** with Flutter and Dart extensions
   - **IntelliJ IDEA** with Flutter plugin

4. **Platform-specific tools**
   
   **For Android:**
   - Android Studio
   - Android SDK (API level 21+)
   - Android Virtual Device (AVD) or physical device
   
   **For iOS (macOS only):**
   - Xcode 12.0 or higher
   - iOS Simulator or physical iOS device
   - CocoaPods (`sudo gem install cocoapods`)

## 🔧 Initial Setup

### 1. Clone and Setup Project

```bash
# Clone the repository
git clone <repository-url>
cd gcc_car_hire

# Install Flutter dependencies
flutter pub get

# Generate code (for JSON serialization)
flutter packages pub run build_runner build

# Verify Flutter installation
flutter doctor
```

### 2. API Keys Configuration

#### Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Geocoding API
4. Create credentials (API Key)
5. Configure the API key:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<meta-data 
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>GMSApiKey</key>
<string>YOUR_GOOGLE_MAPS_API_KEY</string>
```

#### Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Add Android app:
   - Package name: `com.gccrentals.app.gcc_car_hire`
   - Download `google-services.json`
   - Place in `android/app/` directory
4. Add iOS app:
   - Bundle ID: `com.gccrentals.app.gccCarHire`
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/` directory

### 3. Environment Variables

Create a `.env` file in the project root:

```env
# API Configuration
API_BASE_URL=https://api.gccrentals.com/v1/
API_TIMEOUT=30000

# Google Maps
GOOGLE_MAPS_API_KEY=your_google_maps_api_key

# Firebase
FIREBASE_PROJECT_ID=your_firebase_project_id

# Development flags
DEBUG_MODE=true
ENABLE_LOGGING=true
```

## 🏗️ Project Structure

```
gcc_car_hire/
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
├── lib/                     # Dart source code
│   ├── core/               # Core application logic
│   │   ├── models/         # Data models
│   │   ├── services/       # Services (API, storage, etc.)
│   │   ├── providers/      # State management
│   │   ├── routing/        # Navigation
│   │   └── theme/          # App theming
│   ├── features/           # Feature modules
│   │   ├── auth/          # Authentication
│   │   ├── home/          # Home screen
│   │   ├── search/        # Vehicle search
│   │   ├── bookings/      # Booking management
│   │   ├── profile/       # User profile
│   │   ├── license/       # License verification
│   │   └── maps/          # Map integration
│   └── main.dart          # App entry point
├── test/                   # Unit tests
├── integration_test/       # Integration tests
├── pubspec.yaml           # Dependencies
└── README.md              # Project documentation
```

## 🔨 Development Workflow

### 1. Running the App

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in debug mode (default)
flutter run

# Run in profile mode
flutter run --profile

# Run in release mode
flutter run --release

# Hot reload (press 'r' in terminal)
# Hot restart (press 'R' in terminal)
```

### 2. Code Generation

The project uses code generation for JSON serialization:

```bash
# Generate code once
flutter packages pub run build_runner build

# Watch for changes and regenerate
flutter packages pub run build_runner watch

# Clean and regenerate
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3. Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/auth_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

### 4. Code Quality

```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/

# Check for unused dependencies
flutter pub deps
```

## 📱 Device Setup

### Android Device

1. **Enable Developer Options:**
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings > Developer Options
   - Enable "USB Debugging"

2. **Connect via USB or WiFi:**
   ```bash
   # Check connected devices
   adb devices
   
   # Connect via WiFi (after USB connection)
   adb tcpip 5555
   adb connect <device-ip>:5555
   ```

### iOS Device

1. **Enable Developer Mode:**
   - Connect device to Mac
   - Open Xcode
   - Go to Window > Devices and Simulators
   - Select your device and trust it

2. **Install on device:**
   ```bash
   # Open iOS project in Xcode
   open ios/Runner.xcworkspace
   
   # Or run directly
   flutter run -d <ios-device-id>
   ```

## 🐛 Debugging

### 1. Flutter Inspector

```bash
# Run with inspector
flutter run --debug

# Open DevTools in browser
flutter pub global activate devtools
flutter pub global run devtools
```

### 2. Logging

The app uses different logging levels:

```dart
// In development
debugPrint('Debug message');
print('General log');

// In production (use logging package)
Logger.info('Info message');
Logger.error('Error message');
```

### 3. Common Issues

**Build Issues:**
```bash
# Clean build
flutter clean
flutter pub get

# Reset iOS pods
cd ios && rm -rf Pods Podfile.lock && pod install
```

**Gradle Issues (Android):**
```bash
cd android
./gradlew clean
cd .. && flutter clean && flutter pub get
```

## 🚀 Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Build with specific flavor
flutter build apk --release --flavor production
```

### iOS

```bash
# Build for iOS
flutter build ios --release

# Build for specific scheme
flutter build ios --release --flavor production
```

## 📊 Performance Monitoring

### 1. Performance Profiling

```bash
# Run in profile mode
flutter run --profile

# Generate performance report
flutter run --profile --trace-startup --verbose
```

### 2. Memory Analysis

```bash
# Run with memory profiling
flutter run --profile --enable-software-rendering
```

## 🔄 State Management

The app uses Provider for state management. Key providers:

- `AuthProvider`: Authentication state
- `SearchProvider`: Vehicle search state
- `BookingProvider`: Booking management
- `ProfileProvider`: User profile state
- `LicenseProvider`: License verification

## 📦 Dependencies Management

### Adding New Dependencies

```bash
# Add regular dependency
flutter pub add package_name

# Add dev dependency
flutter pub add --dev package_name

# Update dependencies
flutter pub upgrade
```

### Key Dependencies

- `provider`: State management
- `go_router`: Navigation
- `dio`: HTTP client
- `hive`: Local storage
- `google_maps_flutter`: Maps integration
- `firebase_auth`: Authentication
- `google_mlkit_text_recognition`: OCR

## 🌐 Backend Integration

### API Configuration

Update the base URL in `lib/core/services/api_service.dart`:

```dart
@RestApi(baseUrl: "https://your-api-domain.com/v1/")
```

### Authentication Flow

1. User logs in → Get JWT token
2. Store token securely
3. Add token to API requests
4. Handle token refresh

## 📋 Troubleshooting

### Common Flutter Issues

1. **"Flutter command not found"**
   - Add Flutter to PATH
   - Restart terminal/IDE

2. **"No connected devices"**
   - Check USB connection
   - Enable USB debugging (Android)
   - Trust computer (iOS)

3. **"Gradle build failed"**
   - Update Android Gradle Plugin
   - Clean and rebuild project

4. **"CocoaPods not installed"**
   ```bash
   sudo gem install cocoapods
   cd ios && pod install
   ```

### IDE-Specific Setup

**VS Code Extensions:**
- Flutter
- Dart
- Flutter Widget Snippets
- Awesome Flutter Snippets

**Android Studio Plugins:**
- Flutter
- Dart
- Flutter Inspector

## 📞 Getting Help

- **Flutter Documentation**: [flutter.dev/docs](https://flutter.dev/docs)
- **Flutter Community**: [flutter.dev/community](https://flutter.dev/community)
- **Stack Overflow**: Tag questions with `flutter`
- **GitHub Issues**: Report bugs in the project repository

---

Happy coding! 🚀
