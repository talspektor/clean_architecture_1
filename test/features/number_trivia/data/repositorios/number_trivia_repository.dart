import 'package:clean_architecture_1/core/platform/network_info.dart';
import 'package:clean_architecture_1/feature/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_1/feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_1/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_1/feature/number_trivia/data/repositories/number_trivia_repository_il.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  MockRemoteDataSource mockRemoteDataSource = MockRemoteDataSource();
  MockLocalDataSource mockLocalDataSource = MockLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();
  NumberTriviaRepository repository = NumberTriviaRepositoryImpl(
    remoteDataSource: mockRemoteDataSource,
    localDataSource: mockLocalDataSource,
    networkInfo: mockNetworkInfo,
  );

  // setUp(() {
  //   mockRemoteDataSource = MockRemoteDataSource();
  //   mockLocalDataSource = MockLocalDataSource();
  //   mockNetworkInfo = MockNetworkInfo();
  //   repository = NumberTriviaRepositoryImpl(
  //     remoteDataSource: mockRemoteDataSource,
  //     localDataSource: mockLocalDataSource,
  //     networkInfo: mockNetworkInfo,
  //   );
  // });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaNumber =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    const NumberTrivia tNUmberTrivia = tNumberTriviaNumber;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call rto remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(1))
            .thenAnswer((_) async => tNumberTriviaNumber);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, const Right(tNUmberTrivia));
      });
    });

    group('device is offline', () {});
  });
}
