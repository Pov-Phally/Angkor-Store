import 'package:equatable/equatable.dart';

import 'exceptions.dart';

sealed class Failures extends Equatable {
  const Failures({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  String get errorMessage => "$statusCode Error: $message";

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailures extends Failures {
  const ServerFailures({required super.message, required super.statusCode});

  ServerFailures.fromException(ServerException exception)
    : super(message: exception.message, statusCode: exception.statusCode);
}

class CacheFailures extends Failures {
  const CacheFailures({required super.message}) : super(statusCode: 404);

  CacheFailures.fromException(CacheException exception)
    : this(message: exception.message);
}
