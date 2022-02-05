import 'package:clean_architecture_1/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState([List props = const <dynamic>[]]);
  @override
  List<Object?> get props => [props];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;
  Loaded({required this.trivia}) : super([trivia]);
}

class Error extends NumberTriviaState {
  final String message;
  Error({required this.message}) : super([message]);
}
