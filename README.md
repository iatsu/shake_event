# shake_event

A cross-platform shake event listener for Flutter applications.

## Installation

First, add `shake_event` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).
```
dependencies:
  shake_event: ^0.0.8
```

### Example
``` dart
import 'package:shake_event/shake_event.dart';

...
class _MyStatefulWidgetState extends State<HomeStatefulWidget> with ShakeHandler {
  @override
  void initState() {
    startListeningShake(20); //20 is the default threshold value for the shake event
    super.initState();
  }

  @override
  void dispose() {
    resetShakeListeners();
    super.dispose();
  }

  @override
  shakeEventListener() {
    //DO ACTIONS HERE
    return super.shakeEventListener();
  }

  ...
}
```
