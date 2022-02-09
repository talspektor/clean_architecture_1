import 'package:clean_architecture_1/core/network/network_info.dart';
import 'package:clean_architecture_1/core/util/input_converter.dart';
import 'package:clean_architecture_1/feature/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_1/feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/usecases/get_concrete_number_tivia.dart';
import 'package:clean_architecture_1/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_1/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feature/number_trivia/data/repositories/number_trivia_repository_il.dart';
import 'feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.I;

Future<void> init() async {
  initFeatures();
  intCore();
  await intExternals();
}

initFeatures() {
  sl.registerFactory<NumberTriviaBloc>(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getNumberRandomTrivia: sl(),
      inputConverter: sl()));
  // Use case
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => GetNumberRandomTrivia(repository: sl()));

  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          networkInfo: sl(), remoteDataSource: sl(), localDataSource: sl()));
  //Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
}

intCore() {
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

intExternals() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => sharedPreferences);
}
