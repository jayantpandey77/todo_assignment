import 'package:equatable/equatable.dart';
import '../../../data/models/post_model.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserPosts extends PostEvent {
  final int userId;

  const LoadUserPosts(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreatePost extends PostEvent {
  final Post post;

  const CreatePost(this.post);

  @override
  List<Object?> get props => [post];
}
