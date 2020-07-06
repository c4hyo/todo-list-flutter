part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class PostIndex extends PostEvent {
  final String token;
  PostIndex({
    @required this.token,
  });
}

class PostCreate extends PostEvent {
  final String token;
  final PostModel model;
  PostCreate({@required this.token, @required this.model});
}

class PostUpdate extends PostEvent {
  final String token;
  final PostModel model;
  final int id;
  PostUpdate({
    @required this.token,
    @required this.model,
    @required this.id,
  });
}

class PostDelete extends PostEvent {
  final String token;
  final int id;
  PostDelete({
    @required this.token,
    @required this.id,
  });
}

class PostPinned extends PostEvent {
  final String token;
  final int id;
  PostPinned({
    @required this.token,
    @required this.id,
  });
}
