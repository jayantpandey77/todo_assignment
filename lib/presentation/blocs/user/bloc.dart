import 'package:assignment/core/api_constants.dart';
import 'package:assignment/presentation/blocs/user/event.dart';
import 'package:assignment/presentation/blocs/user/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<SearchUsers>(_onSearchUsers);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    if (event.refresh || state is UserInitial) {
      emit(UserLoading());
    }

    try {
      final response = await userRepository.getUsers(
        limit: ApiConstants.defaultLimit,
        skip: 0,
      );

      emit(
        UserLoaded(
          users: response.users,
          hasReachedMax: response.users.length < ApiConstants.defaultLimit,
        ),
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadMoreUsers(
    LoadMoreUsers event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;

      if (currentState.hasReachedMax || currentState.isSearching) return;

      try {
        final response = await userRepository.getUsers(
          limit: ApiConstants.defaultLimit,
          skip: currentState.users.length,
        );

        emit(
          currentState.copyWith(
            users: [...currentState.users, ...response.users],
            hasReachedMax: response.users.length < ApiConstants.defaultLimit,
          ),
        );
      } catch (e) {
        // Don't emit error for pagination failures, just ignore
      }
    }
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UserState> emit,
  ) async {
    if (event.query.isEmpty) {
      print('[SEARCH] Query is empty. Triggering ClearSearch');
      add(ClearSearch());
      return;
    }

    try {
      print('[SEARCH] Searching API with query: ${event.query}');

      final response = await userRepository.getUsers(
        limit: ApiConstants.searchLimit,
        skip: 0,
        search: event.query,
      );

      emit(
        UserLoaded(
          users: response.users,
          hasReachedMax: true,
          isSearching: true,
          searchQuery: event.query,
        ),
      );

      print('[SEARCH] Loaded ${response.users.length} users');
    } catch (e) {
      print('[SEARCH] API error: $e');
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<UserState> emit,
  ) async {
    add(LoadUsers());
  }
}
