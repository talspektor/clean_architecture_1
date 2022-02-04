import 'package:clean_architecture_1/core/error/exception.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTrivia> getRandomNumberTrivia();
}
