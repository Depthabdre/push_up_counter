import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';

/// The blueprint (interface) for our sensor
abstract class SensorHelper {
  /// Emits [true] when the chest is near the phone, [false] when far.
  Stream<bool> get proximityStream;
}

/// The actual implementation
class SensorHelperImpl implements SensorHelper {
  @override
  Stream<bool> get proximityStream {
    // The proximity_sensor package returns an int stream.
    // Usually: >0 (or 1) means NEAR. 0 means FAR.
    return ProximitySensor.events.map((int event) {
      return event > 0; 
    });
  }
}