# samir_adaptive_widgets

A powerful Flutter plugin that provides adaptive UI widgets seamlessly translating to native-looking components on both iOS and Android. This package introduces exclusive support for the groundbreaking **iOS 26+ liquid glass designs** while maintaining perfect Material Design fidelity on Android platforms.

## Features

- **True Platform Adaptability**: Automatically renders iOS-style (Cupertino/Liquid Glass) widgets on Apple devices and Material-style widgets on Android.
- **iOS 26+ Liquid Glass Designs**: Next-generation, stunning liquid glass UI components ready to elevate your iOS app interfaces.
- **Extensive UI Kit**: Provides a comprehensive suite of adaptive widgets including buttons, dialogs, scaffolds, switches, tabs, and more.
- **Easy Integration**: Drop-in replacements for standard Flutter widgets.

## Installation

Add `samir_adaptive_widgets` to your `pubspec.yaml`:

```yaml
dependencies:
  samir_adaptive_widgets: ^0.1.0
```

Then run:

```sh
flutter pub get
```

## Quick Start

Import the package in your Dart code:

```dart
import 'package:samir_adaptive_widgets/samir_adaptive_widgets.dart';
```

Use the `AdaptiveApp` as the root of your application, and then use any of the adaptive widgets such as `AdaptiveScaffold`, `AdaptiveAppBar`, and `AdaptiveButton`:

```dart
import 'package:flutter/material.dart';
import 'package:samir_adaptive_widgets/samir_adaptive_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdaptiveApp(
      title: 'Adaptive App Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: Text('Adaptive Scaffold'),
      ),
      body: Center(
        child: AdaptiveButton(
          onPressed: () {
            showAdaptiveDialog(
              context: context,
              builder: (context) => AdaptiveAlertDialog(
                title: const Text('Hello!'),
                content: const Text('This dialog is adaptive.'),
                actions: [
                  AdaptiveButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Show Adaptive Dialog'),
        ),
      ),
    );
  }
}
```

## Available Widgets

### Adaptive Series
Seamlessly adjust their look and feel based on the host platform (Cupertino for iOS, Material for Android).
- `AdaptiveApp` & `AdaptiveScaffold`
- `AdaptiveAppBar` & `AdaptiveBottomNavigationBar`
- `AdaptiveButton`, `AdaptiveSwitch`, `AdaptiveCheckbox`, `AdaptiveRadio`
- `AdaptiveSlider`, `AdaptiveTextField`, `AdaptiveTextFormField`
- `AdaptiveAlertDialog`, `AdaptiveModal`, `AdaptiveSnackbar`
- `AdaptiveCard`, `AdaptiveBadge`, `AdaptiveTooltip`
- `AdaptiveDatePicker`, `AdaptiveTimePicker`
- *And many more...*

### iOS 26 Advanced Widgets
Exclusively access the new iOS 26 "liquid glass" native designs. Use these directly if you specifically want to force the new iOS 26 aesthetics regardless of platform, or as part of the adaptive engine when running on iOS.
- `Ios26Button`
- `Ios26Switch`
- `Ios26Slider`
- `Ios26SegmentedControl`
- `Ios26AlertDialog`
- `Ios26NativeSearchTabBar`
- `Ios26NativeTabBar`
- `Ios26ScaffoldLegacy`

## Platform Setup

### iOS
Ensure your `ios/Podfile` has the required iOS deployment target. The plugin handles the native views.

### Android
Ensure your `android/app/build.gradle` is configured correctly for standard Flutter plugin compatibility.

## Contributions

Contributions, issues, and feature requests are welcome!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
