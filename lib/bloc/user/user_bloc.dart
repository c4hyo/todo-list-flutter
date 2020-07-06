import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todolistv2/export.dart';

part 'user_event.dart';
part 'user_state.dart';

UserRepository _repository = new UserRepository();

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserLogin) {
      yield* _userLogin(event.model);
    } else if (event is UserRegistration) {
      yield* _userRegistration(event.model);
    } else if (event is UserUpdate) {
      yield* _userUpdate(event.id, event.model);
    } else if (event is UserDelete) {
      yield* _userDelete(event.id);
    }
  }
}

Stream<UserState> _userLogin(model) async* {
  yield UserWaiting();
  try {
    UserModel models = await _repository.login(model: model);
    yield UserLoginSuccess(model: models);
  } catch (e) {
    yield UserError(messege: e.toString());
  }
}

Stream<UserState> _userRegistration(model) async* {
  yield UserWaiting();
  try {
    int s = await _repository.registrasi(model: model);
    yield UserSuccess(messege: s.toString());
  } catch (e) {
    yield UserError(messege: e.toString());
  }
}

Stream<UserState> _userUpdate(id, model) async* {
  yield UserWaiting();
  try {
    int s = await _repository.update(model: model, id: id);
    yield UserSuccess(messege: s.toString());
  } catch (e) {
    yield UserError(messege: e.toString());
  }
}

Stream<UserState> _userDelete(id) async* {
  yield UserWaiting();
  try {
    int s = await _repository.delete(id: id);
    yield UserSuccess(messege: s.toString());
  } catch (e) {
    yield UserError(messege: e.toString());
  }
}
