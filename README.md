# GoSaffeCapture Flutter

## Usage

To use GoSaffeCapture in your application, follow these steps:

1. Import the package:

```dart
import 'package:go_saffe_flutter/go_saffe_flutter.dart';
```

2. Create an instance of GoSaffeCapture with the necessary parameters. Note: location must be enabled in our panel.

```dart
GoSaffeCapture(
  captureKey: '',   // capture key (sandbox or production)
  user: '',         // end-user identifier (either email or CPF)
  type: '',         // 'onboarding' or 'verification'
  endToEndId: '',   // identifier to keep consistency between front and backend
  onFinish: () {
    print('Finish event received');
  },
  onClose: () {
    print('Close event received');
  },
  onTimeout: () {
    print('Timeout event received');
  },
  onError: () {
    print('Error received');
  },
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
      captureKey: 'your_api_key',
      user: 'user_identifier',
      type: 'verification | onboarding',
      endToEndId: 'end_to_end_id',
      onFinish: () {
        print('Finish event received');
      },
      onClose: () {
        print('Close event received');
      },
      onTimeout: () {
        print('Timeout event received');
      },
      onError: () {
        print('Error received');
      },
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
