import '../repositories/user_listing_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';

class GetUserList implements UseCase<List<User>, NoParams> {
  final UserListingRepository repository;

  GetUserList(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getUserList();
  }
}
