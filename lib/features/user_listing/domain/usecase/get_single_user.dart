import '../repositories/user_listing_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';

class GetSingleUser implements UseCase<User, Params> {
  final UserListingRepository repository;

  GetSingleUser(this.repository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return await repository.getSingleUser(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({required this.number});

  @override
  List<Object?> get props => [number];
}
