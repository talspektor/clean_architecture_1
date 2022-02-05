import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent([List props = const <dynamic>[]]);
  @override
  List<Object?> get props => [props];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString) : super([numberString]);
}

class GetTriviaFromRandomNumber extends NumberTriviaEvent {}
