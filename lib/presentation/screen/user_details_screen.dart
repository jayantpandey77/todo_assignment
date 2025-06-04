import 'package:assignment/presentation/blocs/post/bloc.dart';
import 'package:assignment/presentation/blocs/post/event.dart';
import 'package:assignment/presentation/blocs/post/state.dart';
import 'package:assignment/presentation/blocs/todo/bloc.dart';
import 'package:assignment/presentation/blocs/todo/event.dart';
import 'package:assignment/presentation/blocs/todo/state.dart';
import 'package:assignment/presentation/widget/error.dart';
import 'package:assignment/presentation/widget/loading_indicator.dart';
import 'package:assignment/presentation/widget/post_card.dart';
import 'package:assignment/presentation/widget/todo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../injection_container.dart' as di;
import '../../data/models/user_model.dart';
import 'create_post_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PostBloc _postBloc;
  late TodoBloc _todoBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _postBloc = di.sl<PostBloc>();
    _todoBloc = di.sl<TodoBloc>();

    // Load user posts and todos
    _postBloc.add(LoadUserPosts(widget.user.id));
    _todoBloc.add(LoadUserTodos(widget.user.id));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _postBloc.close();
    _todoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.fullName),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Posts', icon: Icon(Icons.article)),
            Tab(text: 'Todos', icon: Icon(Icons.check_circle)),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildUserInfo(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildPostsTab(), _buildTodosTab()],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreatePostScreen(user: widget.user),
            ),
          );

          // Refresh posts if a new post was created
          if (result == true) {
            _postBloc.add(LoadUserPosts(widget.user.id));
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Create Post',
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Hero(
                tag: 'user-avatar-${widget.user.id}',
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.user.image,
                  ),
                  onBackgroundImageError: (_, __) {},
                  child: widget.user.image.isEmpty
                      ? Icon(Icons.person, size: 40)
                      : null,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.fullName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${widget.user.username}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.email, size: 16),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.user.email,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16),
                        SizedBox(width: 4),
                        Text(
                          widget.user.phone,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoCards(),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.business, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Company',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.user.company.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.user.company.title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Address',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.user.address.city,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.user.address.state,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostsTab() {
    return BlocProvider.value(
      value: _postBloc,
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return LoadingIndicator();
          } else if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No posts yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create the first post!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: state.posts[index]);
              },
            );
          } else if (state is PostError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => _postBloc.add(LoadUserPosts(widget.user.id)),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget _buildTodosTab() {
    return BlocProvider.value(
      value: _todoBloc,
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return LoadingIndicator();
          } else if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checklist_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No todos found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                return TodoCard(todo: state.todos[index]);
              },
            );
          } else if (state is TodoError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => _todoBloc.add(LoadUserTodos(widget.user.id)),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
