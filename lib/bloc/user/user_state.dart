part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserWaiting extends UserState {}

class UserLoginSuccess extends UserState {
  final UserModel model;
  UserLoginSuccess({this.model});
}

class UserSuccess extends UserState {
  final String messege;
  UserSuccess({this.messege});
}

class UserError extends UserState {
  final String messege;
  UserError({this.messege});
}
