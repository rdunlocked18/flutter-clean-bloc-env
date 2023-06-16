import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserListingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetSingleUserByNumberEvent extends UserListingEvent {
  final int? numberString;

  GetSingleUserByNumberEvent(this.numberString);

  @override
  List<Object?> get props => [numberString];
}

class GetUserListEvent extends UserListingEvent {}
