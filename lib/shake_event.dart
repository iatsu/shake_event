library shake_event;

import 'dart:async';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:sensors/sensors.dart';

class ShakeHandler {
  StreamSubscription<dynamic>? _accelerometerStream;
  StreamSubscription<dynamic>? subscription;

  //INPUT
  var _thresholdController = StreamController<int>();
  // ignore: unused_element
  Sink<int> get _threshold => _thresholdController.sink;

  // OUTPUT
  var _shakeDetector = StreamController<bool>();
  // ignore: unused_element
  Stream<bool> get _shakeEvent =>
      _shakeDetector.stream.transform(ThrottleStreamTransformer(
          (_) => TimerStream(true, const Duration(seconds: 2))));

  double _detectionThreshold = 20.0;

  /// To be overriden to listen to the shake event
  shakeEventListener() {}

  /// Subscribes to the shake event
  startListeningShake(double detectionThreshold) {
    _detectionThreshold = detectionThreshold;
    if (_accelerometerStream == null) {
      _listenForShake();
      _subscribeForReset();
    }
  }

  /// Shake event listener
  /// Calculates the shake with the given threshold (default 20) and
  /// calls the `shakeEventListener` when successful.
  _listenForShake() {
    const CircularBufferSize = 10;

    List<double> circularBuffer = List.filled(CircularBufferSize, 0.0);
    int index = 0;
    double minX = 0.0, maxX = 0.0;

    _thresholdController.stream.listen((value) {
      // safety
      if (value > 30) _detectionThreshold = value * 1.0;
    });

    _accelerometerStream =
        accelerometerEvents.listen((AccelerometerEvent event) {
      index = (index == CircularBufferSize - 1) ? 0 : index + 1;

      var oldX = circularBuffer[index];

      if (oldX == maxX) {
        maxX = circularBuffer.reduce(max);
      }
      if (oldX == minX) {
        minX = circularBuffer.reduce(min);
      }

      circularBuffer[index] = event.x;
      if (event.x < minX) minX = event.x;
      if (event.x > maxX) maxX = event.x;

      if (maxX - minX > _detectionThreshold) {
        shakeEventListener();
        circularBuffer.fillRange(0, CircularBufferSize, 0.0);
        minX = 0.0;
        maxX = 0.0;
      }
    });
  }

  void _restartListener(dynamic) {
    resetShakeListeners();
    _listenForShake();
    _subscribeForReset();
  }

  /// Gets rid of all the existing listeners
  void resetShakeListeners() {
    _shakeDetector.close();
    _thresholdController.close();
    if (_accelerometerStream != null) {
      _accelerometerStream?.cancel();
      _accelerometerStream = null;
    }
    if (subscription != null) {
      subscription?.cancel();
      subscription = null;
    }
    _thresholdController = StreamController<int>();
    _shakeDetector = StreamController<bool>();
  }

  void _subscribeForReset() {
    var future = new Future.delayed(const Duration(milliseconds: 2000));
    subscription = future.asStream().listen(_restartListener);
  }
}
