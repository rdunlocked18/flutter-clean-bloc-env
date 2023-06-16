import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserListingRepository {
  Future<Either<Failure, User>> getSingleUser(int id);
  Future<Either<Failure, List<User>>> getUserList();
}
