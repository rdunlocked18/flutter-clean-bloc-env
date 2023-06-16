import '../../domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserListingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends UserListingState {}

class Loading extends UserListingState {}

class Loaded extends UserListingState {
  final User user;

  Loaded({required this.user});

  @override
  List<Object> get props => [user];
}

class ListLoaded extends UserListingState {
  final List<User> userList;

  ListLoaded({required this.userList});

  @override
  List<Object> get props => [userList];
}

class Error extends UserListingState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
