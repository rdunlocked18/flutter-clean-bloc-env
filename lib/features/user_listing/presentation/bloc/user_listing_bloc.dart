import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecase/get_user_list.dart';
import 'user_listing_event.dart';
import 'user_listing_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecase/get_single_user.dart';

class UserListingBloc extends Bloc<UserListingEvent, UserListingState> {
  final GetSingleUser getSingleUserByNumber;
  final GetUserList getUserList;

  UserListingBloc(
      {required this.getSingleUserByNumber, required this.getUserList})
      : super(Empty()) {
    // Get Single USer
    on<GetSingleUserByNumberEvent>((event, emit) async {
      emit(Loading());
      final failureOrUser = await getSingleUserByNumber(Params(number: 2));
      _emitEitherLoadedOrErrorStateSingle(failureOrUser, emit);
    });

    // Get Multiple Users
    on<GetUserListEvent>((event, emit) async {
      final failureOrUserList = await getUserList(NoParams());
      _emitEitherLoadedOrErrorStateMulti(failureOrUserList, emit);
    });
  }

  void _emitEitherLoadedOrErrorStateSingle(
    Either<Failure, User> failureOrUser,
    Emitter<UserListingState> emit,
  ) {
    failureOrUser.fold(
      (failure) => emit(Error(message: 'User Not Available')),
      (us) => emit(Loaded(user: us)),
    );
  }

  void _emitEitherLoadedOrErrorStateMulti(
    Either<Failure, List<User>> failureOrUser,
    Emitter<UserListingState> emit,
  ) {
    failureOrUser.fold(
      (failure) => emit(Error(message: 'List Not Available')),
      (us) => emit(ListLoaded(userList: us)),
    );
  }
}
