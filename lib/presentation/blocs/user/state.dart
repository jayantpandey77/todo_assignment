import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final bool hasReachedMax;
  final bool isSearching;
  final String searchQuery;

  const UserLoaded({
    required this.users,
    this.hasReachedMax = false,
    this.isSearching = false,
    this.searchQuery = '',
  });

  UserLoaded copyWith({
    List<User>? users,
    bool? hasReachedMax,
    bool? isSearching,
    String? searchQuery,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [users, hasReachedMax, isSearching, searchQuery];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
