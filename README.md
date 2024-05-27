# GoSaffeCapture Flutter

## Usage

To use GoSaffeCapture in your application, follow these steps:

1. Import the package `go_saffe_flutter/go_saffe_flutter.dart`.

```dart
import 'package:go_saffe_flutter/go_saffe_flutter.dart';
```

2. Create an instance of GoSaffeCapture with the necessary parameters, including the API key, user identifier, type, and end-to-end ID. Additionally, define the `onFinish` and `onClose` callback functions to handle the corresponding events received from the WebView.

```dart
GoSaffeCapture(
  captureKey: 'your_api_key',
  user: 'user_identifier',
  type: 'verification | onboarding',
  endToEndId: 'end_to_end_id',
  onFinish: () {
    // Do something when the finish event is received
    print('Finish event received');
  },
  onClose: () {
    // Do something when the close event is received
    print('Close event received');
  },
  onError: () {
    // Do something when the return some error on rendering screen
    print('Error received');
  }
),
```

3. Add the GoSaffeCapture widget where you want it to be displayed in your user interface.

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
        // Do something when the finish event is received
        print('Finish event received');
      },
      onClose: () {
        // Do something when the close event is received
        print('Close event received');
      },
      onError: () {
        // Do something when the return some error on rendering screen
        print('Error received');
      }
    ),
  ),
),
```

Make sure to replace `'your_api_key'`, `'user'` and `'end_to_end_id'` with the actual values needed.

## Support

If you have any questions or encounter any issues, feel free to open an [issue](https://github.com/saffe/go_saffe_flutter/issues) in this repository.
