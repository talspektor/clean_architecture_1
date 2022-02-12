import 'package:clean_architecture_1/core/error/failures.dart';
import 'package:clean_architecture_1/core/usecases/usecase.dart';
import 'package:clean_architecture_1/core/util/input_converter.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/usecases/get_concrete_number_tivia.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_1/feature/number_trivia/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailure =
    'Invalid Input = The number should be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetNumberRandomTrivia getNumberRandomTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getNumberRandomTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      await _onGetTriviaForConcreteNumber(event, emit);
    });

    on<GetTriviaFromRandomNumber>((event, emit) async {
      await _onGetTriviaFromRandomNumber(event, emit);
    });
  }

  _onGetTriviaForConcreteNumber(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);
    await inputEither.fold((failure) {
      emit(Error(message: invalidInputFailure));
    }, (integer) async {
      emit(Loading());
      final failureOrTrivia =
          await getConcreteNumberTrivia(Params(number: integer));
      _eitherLoadedOrErrorState(failureOrTrivia, emit);
    });
  }

  _onGetTriviaFromRandomNumber(
      GetTriviaFromRandomNumber event, Emitter<NumberTriviaState> emit) async {
    emit(Loading());
    final failureOrTrivia = await getNumberRandomTrivia(NoParams());
    _eitherLoadedOrErrorState(failureOrTrivia, emit);
  }

  _eitherLoadedOrErrorState(Either<Failure, NumberTrivia> failureOrTrivia,
      Emitter<NumberTriviaState> emit) {
    failureOrTrivia.fold(
        (failure) => emit(Error(message: _mapFailureToMessage(failure))),
        (trivia) => emit(Loaded(trivia: trivia)));
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
