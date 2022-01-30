import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

// General failures

class ServerFailure extends Equatable {
  final String message;

  const ServerFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Equatable {
  final String message;

  const CacheFailure(this.message);

  @override
  List<Object?> get props => [message];
}
