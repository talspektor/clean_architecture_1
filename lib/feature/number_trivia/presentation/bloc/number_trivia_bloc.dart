import 'package:clean_architecture_1/core/error/failures.dart';
import 'package:clean_architecture_1/core/util/input_converter.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/usecases/get_concrete_number_tivia.dart';
import 'package:clean_architecture_1/feature/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailure =
    'Invalid Input = The number should be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetTriviaFromRandomNumber getTriviaFromRandomNumber;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getTriviaFromRandomNumber,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      inputEither.fold((failure) {
        emit(Error(message: invalidInputFailure));
      }, (integer) async {
        emit(Loading());
        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        failureOrTrivia.fold(
            (failure) => emit(Error(message: _mapFailureToMessage(failure))),
            (trivia) => emit(Loaded(trivia: trivia)));
      });
    });

    on<GetTriviaFromRandomNumber>((event, emit) {});
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
