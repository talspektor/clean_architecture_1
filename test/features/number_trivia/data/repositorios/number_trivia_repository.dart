import 'package:clean_architecture_1/core/error/failures.dart';
import 'package:clean_architecture_1/core/network/network_info.dart';
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

  runTextOnline(Function body) {
    group('device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    body();
  }

  runTextOffline(Function body) {
    group('device is offline', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    body();
  }

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

    runTextOnline(() {
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
        expect(result, equals(const Right(tNUmberTrivia)));
      });

      test(
          'should cache the data locally when the call rto remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(1))
            .thenAnswer((_) async => tNumberTriviaNumber);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNUmberTrivia)));
      });
    });

    runTextOffline(() {
      test(
          'should return last locally cached data when the cached dada is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaNumber);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNUmberTrivia)));
      });

      test('should return CacheFailure when there is no cached dada  present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaNumber);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure(''))));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaNumber =
        NumberTriviaModel(text: 'test trivia', number: 123);
    const NumberTrivia tNUmberTrivia = tNumberTriviaNumber;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected);
    });

    runTextOnline(() {
      test(
          'should return remote data when the call rto remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(1))
            .thenAnswer((_) async => tNumberTriviaNumber);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNUmberTrivia)));
      });

      test(
          'should cache the data locally when the call rto remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaNumber);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNUmberTrivia)));
      });
    });

    runTextOffline(() {
      test(
          'should return last locally cached data when the cached dada is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaNumber);

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNUmberTrivia)));
      });

      test('should return CacheFailure when there is no cached dada  present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaNumber);

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure(''))));
      });
    });
  });
}
