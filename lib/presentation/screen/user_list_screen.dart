import 'package:assignment/core/debouncer.dart';
import 'package:assignment/data/models/user_model.dart';
import 'package:assignment/presentation/blocs/theme/bloc.dart';
import 'package:assignment/presentation/blocs/theme/state.dart';
import 'package:assignment/presentation/blocs/user/bloc.dart';
import 'package:assignment/presentation/blocs/user/event.dart';
import 'package:assignment/presentation/blocs/user/state.dart';
import 'package:assignment/presentation/screen/user_details_screen.dart';
import 'package:assignment/presentation/widget/error.dart';
import 'package:assignment/presentation/widget/loading_indicator.dart';
import 'package:assignment/presentation/widget/search_bar.dart';
import 'package:assignment/presentation/widget/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart' as di;

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _showSearchResults = false;
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = di.sl<UserBloc>();
    _scrollController.addListener(_onScroll);
    _userBloc.add(LoadUsers());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debouncer.dispose();
    _userBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _userBloc.add(LoadMoreUsers());
    }
  }

  Widget _buildUserList(List<User> users, bool hasReachedMax) {
    return RefreshIndicator(
      onRefresh: () async {
        _userBloc.add(LoadUsers(refresh: true));
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: hasReachedMax ? users.length : users.length + 1,
        itemBuilder: (context, index) {
          if (index >= users.length) return LoadingIndicator();
          final user = users[index];
          return UserCard(
            user: user,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserDetailScreen(user: user),
                  ),
                ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) {
        final user = _filteredUsers[index];
        return UserCard(
          user: user,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
              ),
        );
      },
    );
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    _debouncer.run(() {
      if (query.isEmpty) {
        setState(() {
          _showSearchResults = false;
        });
        _userBloc.add(ClearSearch());
      } else {
        setState(() {
          _showSearchResults = true;
        });
        _userBloc.add(SearchUsers(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Users'),
          actions: [
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    state.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: CustomSearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: 'Search users...',
              ),
            ),
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) return LoadingIndicator();
                  if (state is UserLoaded) {
                    _allUsers = state.users;

                    if (_showSearchResults &&
                        _searchController.text.isNotEmpty) {
                      _filteredUsers =
                          _allUsers
                              .where(
                                (user) => user.fullName.toLowerCase().contains(
                                  _searchController.text.toLowerCase(),
                                ),
                              )
                              .toList();
                      return _buildSearchResults();
                    }

                    return _buildUserList(state.users, state.hasReachedMax);
                  } else if (state is UserError) {
                    return CustomErrorWidget(
                      message: state.message,
                      onRetry: () => _userBloc.add(LoadUsers()),
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
