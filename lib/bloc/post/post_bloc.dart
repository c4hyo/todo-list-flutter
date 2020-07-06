import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todolistv2/export.dart';

part 'post_event.dart';
part 'post_state.dart';

PostRepository _r = new PostRepository();

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is PostIndex) {
      try {
        List<PostModel> list = await _r.index(token: event.token);
        yield PostLoaded(model: list);
      } catch (e) {
        yield PostError(messege: e.toString());
      }
    } else if (event is PostCreate) {
      if (state is PostLoaded) {
        yield PostWaiting();
        try {
          await _r.create(models: event.model, token: event.token);
          List<PostModel> list = await _r.index(token: event.token);
          yield PostLoaded(model: list);
        } catch (e) {
          yield PostError(messege: e.toString());
        }
      }
    } else if (event is PostUpdate) {
      if (state is PostLoaded) {
        yield PostWaiting();
        try {
          await _r.update(
              models: event.model, token: event.token, id: event.id);
          List<PostModel> list = await _r.index(token: event.token);
          yield PostLoaded(model: list);
        } catch (e) {
          yield PostError(messege: e.toString());
        }
      }
    } else if (event is PostDelete) {
      if (state is PostLoaded) {
        yield PostWaiting();
        try {
          await _r.delete(id: event.id, token: event.token);
          List<PostModel> list = await _r.index(token: event.token);
          yield PostLoaded(model: list);
        } catch (e) {
          yield PostError(messege: e.toString());
        }
      }
    } else if (event is PostPinned) {
      if (state is PostLoaded) {
        yield PostWaiting();
        try {
          await _r.pin(id: event.id, token: event.token);
          List<PostModel> list = await _r.index(token: event.token);
          yield PostLoaded(model: list);
        } catch (e) {
          yield PostError(messege: e.toString());
        }
      }
    }
  }
}
