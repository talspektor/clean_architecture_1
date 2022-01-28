import 'package:clean_architecture_1/core/usecases/usecase.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

main() {
  MockNumberTriviaRepository mockNumberTriviaRepository =
      MockNumberTriviaRepository();
  GetNumberRandomTrivia usecase =
      GetNumberRandomTrivia(repository: mockNumberTriviaRepository);

  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia from the repository', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(NoParams());

    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
