# Testing Guide - GCC Car Hire App

This guide covers how to test the app locally, build for distribution, and share with testers.

## 🧪 Testing Methods

### 1. Local Development Testing

#### Prerequisites
- Flutter SDK installed and configured
- Android Studio / VS Code with Flutter plugins
- Physical device or emulator/simulator

#### Run on Development Device
```bash
# Navigate to project directory
cd gcc_car_hire

# Check available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in debug mode (default)
flutter run

# Run in profile mode (for performance testing)
flutter run --profile

# Run in release mode (closest to production)
flutter run --release
```

### 2. Build APK for Android Testing

#### Debug APK (Quick Testing)
```bash
# Build debug APK
flutter build apk --debug

# APK location: build/app/outputs/flutter-apk/app-debug.apk
```

#### Release APK (Production-like Testing)
```bash
# Build release APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

#### App Bundle (Google Play Store)
```bash
# Build App Bundle for Play Store
flutter build appbundle --release

# AAB location: build/app/outputs/bundle/release/app-release.aab
```

### 3. Build IPA for iOS Testing

#### Prerequisites for iOS
- macOS with Xcode installed
- Apple Developer Account (for device testing)
- iOS device or simulator

#### Debug Build
```bash
# Build for iOS simulator
flutter build ios --debug --simulator

# Build for iOS device
flutter build ios --debug
```

#### Release Build
```bash
# Build release version
flutter build ios --release

# Open in Xcode for signing and distribution
open ios/Runner.xcworkspace
```

## 📱 Distribution Methods

### 1. Direct APK Installation (Android)

#### Share APK File
1. Build release APK: `flutter build apk --release`
2. Share the APK file from `build/app/outputs/flutter-apk/app-release.apk`
3. Testers need to enable "Install from Unknown Sources" in Android settings

#### Installation Steps for Testers
1. Download APK file to Android device
2. Go to Settings > Security > Install Unknown Apps
3. Enable installation for your file manager/browser
4. Tap the APK file to install

### 2. Firebase App Distribution

#### Setup Firebase App Distribution
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init

# Install Firebase App Distribution plugin
flutter pub add firebase_app_distribution
```

#### Distribute via Firebase
```bash
# Build release APK
flutter build apk --release

# Upload to Firebase App Distribution
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_FIREBASE_APP_ID \
  --groups "testers" \
  --release-notes "Initial testing build"
```

### 3. TestFlight (iOS)

#### Setup TestFlight Distribution
1. Build release IPA: `flutter build ios --release`
2. Open Xcode: `open ios/Runner.xcworkspace`
3. Archive the app (Product > Archive)
4. Upload to App Store Connect
5. Add testers in TestFlight

### 4. Google Play Console (Internal Testing)

#### Setup Internal Testing
1. Build App Bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Create Internal Testing track
4. Add testers via email addresses

## 🔧 Pre-Testing Setup

### 1. Configure API Keys

Before building for testing, ensure API keys are configured:

#### Google Maps API Key
```bash
# Android: android/app/src/main/AndroidManifest.xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_GOOGLE_MAPS_API_KEY"/>

# iOS: ios/Runner/Info.plist
<key>GMSApiKey</key>
<string>YOUR_GOOGLE_MAPS_API_KEY</string>
```

#### Firebase Configuration
```bash
# Add Firebase config files:
# Android: android/app/google-services.json
# iOS: ios/Runner/GoogleService-Info.plist
```

### 2. Build Signing (Android)

#### Create Keystore for Release Builds
```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Create key.properties file
echo "storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=C:/path/to/upload-keystore.jks" > android/key.properties
```

#### Update build.gradle
```gradle
// android/app/build.gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## 📋 Testing Checklist

### Functional Testing
- [ ] App launches successfully
- [ ] Onboarding flow works
- [ ] Login/Registration screens function
- [ ] Navigation between tabs works
- [ ] Search functionality works
- [ ] Map view displays correctly
- [ ] Profile screens accessible
- [ ] License verification flow works
- [ ] Camera/gallery access works
- [ ] OCR text recognition works

### Performance Testing
- [ ] App startup time < 3 seconds
- [ ] Smooth scrolling in lists
- [ ] Map rendering performance
- [ ] Image loading performance
- [ ] Memory usage acceptable
- [ ] Battery usage reasonable

### Device Testing
- [ ] Different screen sizes
- [ ] Different Android versions (API 21+)
- [ ] Different iOS versions (12.0+)
- [ ] Portrait/landscape orientations
- [ ] Different device manufacturers

### Network Testing
- [ ] Works on WiFi
- [ ] Works on mobile data
- [ ] Handles network interruptions
- [ ] Offline functionality (where applicable)
- [ ] API error handling

## 🚀 Quick Testing Commands

### Build and Test Locally
```bash
# Clean and get dependencies
flutter clean && flutter pub get

# Run code generation
flutter packages pub run build_runner build

# Test on connected device
flutter run --release

# Run tests
flutter test
```

### Build for Distribution
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (on macOS)
flutter build ios --release
```

### Share APK Quickly
```bash
# Build APK
flutter build apk --release

# Copy to easily accessible location
cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/GCC-Car-Hire.apk

# Share the APK file from Desktop
```

## 📧 Tester Instructions Template

### Email Template for Testers

**Subject: GCC Car Hire App - Testing Invitation**

Hi [Tester Name],

You're invited to test the GCC Car Hire mobile app. Please follow these steps:

**For Android:**
1. Download the attached APK file
2. Enable "Install from Unknown Sources" in your device settings
3. Install the APK by tapping on it
4. Test the app and provide feedback

**For iOS:**
1. Check your email for TestFlight invitation
2. Install TestFlight app from App Store
3. Accept the invitation and install the app
4. Test and provide feedback

**Testing Focus Areas:**
- User registration and login
- Vehicle search and filtering
- Map functionality
- Profile management
- License verification (camera/OCR)
- Overall user experience

**Feedback Form:** [Link to feedback form]

**Known Limitations:**
- Backend APIs are mock data
- Payment processing not yet implemented
- Some social login features are placeholders

Please report any bugs or suggestions!

Thanks,
GCC Car Hire Development Team

## 🐛 Troubleshooting

### Common Build Issues
```bash
# Clean build cache
flutter clean
flutter pub get

# Reset iOS pods
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..

# Clear Android cache
cd android && ./gradlew clean && cd ..
```

### APK Installation Issues
- Enable "Install from Unknown Sources"
- Check available storage space
- Ensure Android version compatibility (API 21+)
- Try installing via ADB: `adb install app-release.apk`

### iOS Testing Issues
- Ensure device is registered in Apple Developer account
- Check provisioning profiles
- Verify bundle identifier matches
- Use Xcode for detailed error messages

---

Happy Testing! 🚀
