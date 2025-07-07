# GoSaffeCapture Flutter

## Usage

To use GoSaffeCapture in your application, follow these steps:

1. Import the package:

```dart
import 'package:go_saffe_flutter/go_saffe_flutter.dart';
```

2. Create an instance of GoSaffeCapture with the necessary parameters. Note: location must be enabled in our panel.

```dart
// Basic usage without extraData
GoSaffeCapture(
  '<CAPTURE_KEY>',              // capture key (sandbox or production)
  '<USER_IDENTIFIER>',          // end-user identifier (either email or CPF)
  'verification | onboarding',         // 'onboarding' or 'verification'
  '<END_TO_END_ID>',              // identifier to keep consistency between front and backend
  () { print('Finish event received'); },
  () { print('Close event received'); },
  () { print('Timeout event received'); },
  () { print('Error received'); },
),
```

3. Add the widget where desired:

```dart
Scaffold(
  appBar: AppBar(
    title: Text('Example of GoSaffeCapture'),
  ),
  body: Center(
    child: GoSaffeCapture(
      'your_api_key',
      'user_identifier',
      'verification | onboarding',
      'end_to_end_id',
      () {
        print('Finish event received');
      },
      () {
        print('Close event received');
      },
      () {
        print('Timeout event received');
      },
      () {
        print('Error received');
      },
    ),
  ),
),
```

## Extra Data (Optional)

The `extraData` parameter allows you to customize the appearance and behavior of the GoSaffeCapture widget. It's a named parameter, so you only need to include it when you want to customize the widget. If you don't want any customization, simply omit the parameter.

### Creating ExtraData

All fields in `Settings` are optional. You can customize only the fields you need:

```dart
// Example with all settings
final extraData = ExtraData(
  settings: Settings(
    primaryColor: '#FF0000',     // Primary color in hex format
    secondaryColor: '#00FF00',   // Secondary color in hex format
    lang: 'pt',                  // Language code (e.g., 'pt', 'en', 'es')
  ),
);

// Example with only primary color
final extraDataMinimal = ExtraData(
  settings: Settings(
    primaryColor: '#1976D2',
  ),
);

// Example with only language
final extraDataLang = ExtraData(
  settings: Settings(
    lang: 'en',
  ),
);
```

### Using ExtraData

Simply add the `extraData` parameter as a named parameter when creating the GoSaffeCapture widget:

```dart
GoSaffeCapture(
  'your_api_key',
  'user_identifier',
  'verification',
  'end_to_end_id',
  () { print('Finish event received'); },
  () { print('Close event received'); },
  () { print('Timeout event received'); },
  () { print('Error received'); },
  extraData: extraData, // Add this line to customize
),
```

### Complete Example with ExtraData

```dart
final extraData = ExtraData(
  settings: Settings(
    primaryColor: '#00ABAB',
    secondaryColor: '#FFC107',
    lang: 'pt',
  ),
);

Scaffold(
  appBar: AppBar(
    title: Text('GoSaffeCapture with Custom Settings'),
  ),
  body: Center(
    child: GoSaffeCapture(
      'your_api_key',
      'user_identifier',
      'verification',
      'end_to_end_id',
      () { print('Finish event received'); },
      () { print('Close event received'); },
      () { print('Timeout event received'); },
      () { print('Error received'); },
      extraData: extraData,
    ),
  ),
),
```

## Native Configuration

This widget uses a WebView that requires native permissions for camera and location access.  
Make sure to update the native configuration in your app and note that location must be enabled in our panel.

### iOS (Info.plist)

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need location access</string>
```

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

## Support

If you have any questions or issues, feel free to open an [issue](https://github.com/saffe/go_saffe_flutter/issues) in this repository.
