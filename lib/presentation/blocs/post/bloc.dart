import 'package:assignment/presentation/blocs/post/event.dart';
import 'package:assignment/presentation/blocs/post/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/post_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc(this.postRepository) : super(PostInitial()) {
    on<LoadUserPosts>(_onLoadUserPosts);
    on<CreatePost>(_onCreatePost);
  }

  Future<void> _onLoadUserPosts(
    LoadUserPosts event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());

    try {
      final posts = await postRepository.getUserPosts(event.userId);
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
    try {
      final createdPost = await postRepository.createPost(event.post);
      emit(PostCreated(createdPost));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
