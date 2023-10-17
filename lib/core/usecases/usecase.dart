import 'package:dartz/dartz.dart';
import 'package:trivia_flutter_tdd_clean_architecture/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>?> call(Params params);
}
