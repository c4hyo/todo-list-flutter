part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostWaiting extends PostState {}

class PostSuccess extends PostState {
  final String messege;
  PostSuccess({this.messege});
}

class PostError extends PostState {
  final String messege;
  PostError({this.messege});
}

class PostLoaded extends PostState {
  final List<PostModel> model;
  PostLoaded({this.model});
}
