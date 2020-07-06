part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserLogin extends UserEvent {
  final UserModel model;
  UserLogin({@required this.model});
}

class UserRegistration extends UserEvent {
  final UserModel model;
  UserRegistration({@required this.model});
}

class UserUpdate extends UserEvent {
  final UserModel model;
  final int id;
  UserUpdate({@required this.model, @required this.id});
}

class UserDelete extends UserEvent {
  final int id;
  UserDelete({@required this.id});
}
