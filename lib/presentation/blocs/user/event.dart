import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {
  final bool refresh;

  const LoadUsers({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class LoadMoreUsers extends UserEvent {}

class SearchUsers extends UserEvent {
  final String query;

  const SearchUsers(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends UserEvent {}
