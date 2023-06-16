import 'features/user_listing/data/datasources/user_listing_local_data_source.dart';
import 'features/user_listing/data/datasources/user_listing_remote_data_source.dart';
import 'features/user_listing/domain/repositories/user_listing_repository.dart';
import 'features/user_listing/domain/usecase/get_single_user.dart';
import 'features/user_listing/domain/usecase/get_user_list.dart';
import 'features/user_listing/presentation/bloc/user_listing_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/user_listing/data/repositories/user_listing_repository_impl.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia ,F2 User Listing
  // Bloc --------------------
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      inputConverter: sl(),
      getRandomNumberTrivia: sl(),
    ),
  );
  // === F2- User Listing
  sl.registerFactory(
    () => UserListingBloc(
      getSingleUserByNumber: sl(),
      getUserList: sl(),
    ),
  );
  // Bloc --------------------

  // Use cases --------------------
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  // === F2- User Listing
  sl.registerLazySingleton(() => GetSingleUser(sl()));
  sl.registerLazySingleton(() => GetUserList(sl()));
  // Use cases --------------------

  // Repository --------------------
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // === F2- User Listing
  sl.registerLazySingleton<UserListingRepository>(
    () => UserListingRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  // Repository --------------------

  // Data sources --------------------
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // === F2- User Listing

  sl.registerLazySingleton<UserListingLocalDataSource>(
    () => UserListingLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<UserListingRemoteDataSource>(
    () => UserListingRemoteDataSourceImpl(client: sl()),
  );
  // Data sources --------------------

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
