import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

typedef DataMap = Map<String, dynamic>;
typedef ResultFuture<T> = Future<Either<Failures, T>>;
