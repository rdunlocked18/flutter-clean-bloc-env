import '../datasources/user_listing_local_data_source.dart';
import '../datasources/user_listing_remote_data_source.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_listing_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

typedef Future<UserModel> _SingleChooser();
typedef Future<List<UserModel>> _ListChooser();

class UserListingRepositoryImpl implements UserListingRepository {
  final UserListingRemoteDataSource remoteDataSource;
  final UserListingLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserListingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getSingleUser(
    int number,
  ) async {
    return await _getSingleUser(() {
      return remoteDataSource.getSingleUser(number);
    });
  }

  @override
  Future<Either<Failure, List<User>>> getUserList() async {
    return await _getListOfUsers(() {
      return remoteDataSource.getUserList();
    });
  }

  Future<Either<Failure, User>> _getSingleUser(
    _SingleChooser _singleChooser,
  ) async {
    if (await networkInfo.isConnected) {
      return await _fetchSingleRemoteUser(_singleChooser);
    } else {
      return await _getCachedUser();
    }
  }

  Future<Either<Failure, List<User>>> _getListOfUsers(
    _ListChooser _listChooser,
  ) async {
    if (await networkInfo.isConnected) {
      return await _fetchListRemoteUser(_listChooser);
    } else {
      return await _getCachedUserForList();
    }
  }

  Future<Either<Failure, User>> _fetchSingleRemoteUser(
      _SingleChooser _singleChooser) async {
    try {
      final remoteTrivia = await _singleChooser();
      localDataSource.cacheUser(remoteTrivia);
      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, List<User>>> _fetchListRemoteUser(
      _ListChooser _listChooser) async {
    try {
      final remoteTrivia = await _listChooser();
      localDataSource.cacheUser(remoteTrivia.first);
      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, User>> _getCachedUser() async {
    try {
      final localUser = await localDataSource.getLastUser();

      return Right(localUser);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, List<User>>> _getCachedUserForList() async {
    try {
      final localUser = await localDataSource.getLastUser();

      List<User> listUser = [];
      listUser.add(localUser);

      return Right(listUser);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
