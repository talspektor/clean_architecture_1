import 'dart:convert';

import 'package:clean_architecture_1/core/error/exception.dart';
import 'package:clean_architecture_1/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  /// Get the cache [NumberTriviaModel] which was gotten the last time.
  /// the user had an internet connection
  /// Throws  [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  NumberTriviaLocalDataSourceImpl();

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final SharedPreferences pref = await sharedPreferences;
    final jsonString = pref.getString(cachedNumberTrivia);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }
    throw CacheException('');
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    final SharedPreferences pref = await sharedPreferences;
    return pref.setString(
        cachedNumberTrivia, json.encode(triviaToCache.toJson()));
  }
}
