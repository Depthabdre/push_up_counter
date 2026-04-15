import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// Used when something goes wrong with SharedPreferences
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

// Used if the device doesn't have a proximity sensor or it breaks
class DeviceFailure extends Failure {
  const DeviceFailure({required super.message});
}
