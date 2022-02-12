import 'package:clean_architecture_1/feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_1/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_1/feature/number_trivia/data/repositories/number_trivia_repository_il.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

main() {
  NumberTriviaRepositoryImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  group('getLastNumberTrivia', () {
    mockSharedPreferences = MockSharedPreferences();
    // dataSource = NumberTriviaLocalDataSourceImpl(
    //     sharedPreferences: mockSharedPreferences);
    //
    // final tNumberTriviaModel = NumberTriviaModel.fromJson()
    //
    // test('should return NumberTrivia from SharedPreferences when there is one in the cache.',() async {
    //   when()
    // });
  });
}
