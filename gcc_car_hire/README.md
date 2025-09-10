# GCC Car Hire Mobile App

A cross-platform mobile application for car rental services targeting the GCC region (UAE, Saudi Arabia, Qatar, Bahrain, Oman, Kuwait).

## 🚗 Features

### Core Features
- **User Authentication**: Login, registration, and social login integration
- **Vehicle Search**: Advanced search with filters and map view
- **Booking Management**: Create, view, and manage car rentals
- **Profile Management**: User profile with license verification
- **License Verification**: OCR-powered driving license validation
- **Location Services**: GCC region compliance and location-based search
- **Real-time Maps**: Google Maps integration for vehicle locations

### Technical Features
- Cross-platform (iOS & Android) using Flutter
- Provider state management
- Secure API integration with JWT authentication
- Local data caching with Hive
- OCR text recognition for license verification
- GCC region geo-compliance
- Modern Material Design 3 UI

## 🏗️ Architecture

```
lib/
├── core/                    # Core application logic
│   ├── models/             # Data models
│   ├── services/           # API, storage, location services
│   ├── providers/          # State management setup
│   ├── routing/            # Navigation configuration
│   └── theme/              # App theming
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── home/              # Home screen
│   ├── search/            # Vehicle search
│   ├── bookings/          # Booking management
│   ├── profile/           # User profile
│   ├── license/           # License verification
│   └── maps/              # Map integration
└── main.dart              # App entry point
```

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.10+
- **State Management**: Provider
- **Navigation**: GoRouter
- **HTTP Client**: Dio + Retrofit
- **Local Storage**: Hive + SharedPreferences
- **Maps**: Google Maps Flutter
- **OCR**: Google ML Kit Text Recognition
- **Authentication**: Firebase Auth
- **Push Notifications**: Firebase Messaging

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Xcode (for iOS development)
- Google Maps API Key
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd gcc_car_hire
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   
   **Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
              android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
   ```
   
   **iOS** (`ios/Runner/Info.plist`):
   ```xml
   <key>GMSApiKey</key>
   <string>YOUR_GOOGLE_MAPS_API_KEY</string>
   ```

4. **Firebase Configuration**
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`

5. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Environment Setup

The app requires several API keys and configuration:

1. **Google Maps API Key**
   - Enable Maps SDK for Android/iOS
   - Enable Places API
   - Enable Geocoding API

2. **Firebase Configuration**
   - Authentication
   - Cloud Messaging
   - Analytics (optional)

3. **Backend API**
   - Update base URL in `lib/core/services/api_service.dart`
   - Configure authentication endpoints

### Build Configuration

**Android**:
- Minimum SDK: 21
- Target SDK: 34
- Compile SDK: 34

**iOS**:
- Minimum iOS: 12.0
- Target iOS: 17.0

## 🌍 GCC Region Compliance

The app enforces strict geo-compliance for GCC countries:

- **Supported Countries**: UAE, Saudi Arabia, Qatar, Bahrain, Oman, Kuwait
- **Location Validation**: GPS coordinates checked against GCC boundaries
- **Data Residency**: AWS Middle East (UAE) region
- **Legal Compliance**: GDPR/CCPA ready, GCC PDPL compliant

## 📱 Screens & Features

### Authentication Flow
- **Onboarding**: Multi-page app introduction
- **Login**: Email/password + social login
- **Registration**: User signup with validation

### Main Application
- **Home**: Quick search, featured vehicles, recent bookings
- **Search**: Vehicle listing with filters and map view
- **Bookings**: Active, upcoming, and past rentals
- **Profile**: User management and settings

### License Verification
- **Camera Integration**: Capture license photos
- **OCR Processing**: Extract text from license images
- **Backend Validation**: AI-powered license verification

## 🔐 Security Features

- JWT token authentication
- Secure local storage encryption
- API request/response encryption
- License verification with confidence scoring
- GCC region geo-fencing
- Biometric authentication support (planned)

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run widget tests
flutter test test/widget_test.dart
```

## 📦 Build & Deployment

### Android
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

## 🔄 State Management

The app uses Provider for state management with the following providers:

- `AuthProvider`: User authentication and session management
- `SearchProvider`: Vehicle search and filtering
- `BookingProvider`: Booking operations and history
- `ProfileProvider`: User profile management
- `LicenseProvider`: License verification workflow

## 🗂️ Data Models

Key data models include:

- `UserModel`: User profile and authentication data
- `VehicleModel`: Vehicle information and availability
- `BookingModel`: Rental booking details
- `LicenseVerificationResult`: License validation results

## 🌐 API Integration

The app integrates with a RESTful backend API:

- **Base URL**: `https://api.gccrentals.com/v1/`
- **Authentication**: JWT Bearer tokens
- **Endpoints**: Auth, Users, Vehicles, Bookings, Payments
- **Error Handling**: Standardized error responses

## 📋 Development Roadmap

### Sprint 1-2 (Foundation) ✅
- Project setup and architecture
- Authentication screens
- Basic navigation and UI
- State management setup
- API service layer

### Sprint 3-4 (Core Features) 🚧
- License verification with OCR
- Google Maps integration
- Vehicle search and booking
- Payment integration
- Push notifications

### Sprint 5-6 (Enhancement) 📋
- Offline support
- Performance optimization
- Advanced filters
- Social features
- Analytics integration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Email: support@gccrentals.com
- Documentation: [docs.gccrentals.com](https://docs.gccrentals.com)
- Issues: [GitHub Issues](https://github.com/gccrentals/mobile-app/issues)

## 🏆 Acknowledgments

- Flutter team for the amazing framework
- Google Maps team for location services
- Firebase team for backend services
- GCC regulatory authorities for compliance guidelines

---

**Built with ❤️ for the GCC region**
