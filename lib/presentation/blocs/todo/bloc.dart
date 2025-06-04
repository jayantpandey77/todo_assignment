import 'package:assignment/presentation/blocs/todo/event.dart';
import 'package:assignment/presentation/blocs/todo/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc(this.todoRepository) : super(TodoInitial()) {
    on<LoadUserTodos>(_onLoadUserTodos);
  }

  Future<void> _onLoadUserTodos(
    LoadUserTodos event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());

    try {
      final todos = await todoRepository.getUserTodos(event.userId);
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
