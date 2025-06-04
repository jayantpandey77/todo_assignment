import 'package:assignment/presentation/blocs/post/bloc.dart';
import 'package:assignment/presentation/blocs/post/event.dart';
import 'package:assignment/presentation/blocs/post/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart' as di;
import '../../data/models/user_model.dart';
import '../../data/models/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  final User user;

  const CreatePostScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _tagsController = TextEditingController();
  late PostBloc _postBloc;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _postBloc = di.sl<PostBloc>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    _postBloc.close();
    super.dispose();
  }

  List<String> _parseTags(String tagsText) {
    if (tagsText.trim().isEmpty) return [];
    return tagsText
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  void _createPost() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
    });

    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch, // Generate unique ID
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      userId: widget.user.id,
      tags: _parseTags(_tagsController.text),
      reactions: 0,
      views: 0,
      isLocal: true,
    );

    _postBloc.add(CreatePost(post));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _postBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
          actions: [
            BlocListener<PostBloc, PostState>(
              listener: (context, state) {
                if (state is PostCreated) {
                  setState(() {
                    _isCreating = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Post created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(
                    context,
                    true,
                  ); // Return true to indicate success
                } else if (state is PostError) {
                  setState(() {
                    _isCreating = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: TextButton(
                onPressed: _isCreating ? null : _createPost,
                child:
                    _isCreating
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                        : Text(
                          'POST',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              _buildUserInfo(),
              SizedBox(height: 24),
              _buildTitleField(),
              SizedBox(height: 16),
              _buildBodyField(),
              SizedBox(height: 16),
              _buildTagsField(),
              SizedBox(height: 24),
              _buildPreview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  widget.user.image.isNotEmpty
                      ? NetworkImage(widget.user.image)
                      : null,
              child: widget.user.image.isEmpty ? Icon(Icons.person) : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@${widget.user.username}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Post Title',
        hintText: 'Enter a catchy title...',
        prefixIcon: Icon(Icons.title),
        counterText: '',
      ),
      maxLength: 100,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        if (value.trim().length < 3) {
          return 'Title must be at least 3 characters';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildBodyField() {
    return TextFormField(
      controller: _bodyController,
      decoration: InputDecoration(
        labelText: 'Post Content',
        hintText: 'What\'s on your mind?',
        prefixIcon: Icon(Icons.article),
        alignLabelWithHint: true,
      ),
      maxLines: 8,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter some content';
        }
        if (value.trim().length < 10) {
          return 'Content must be at least 10 characters';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildTagsField() {
    return TextFormField(
      controller: _tagsController,
      decoration: InputDecoration(
        labelText: 'Tags (Optional)',
        hintText: 'technology, flutter, mobile',
        prefixIcon: Icon(Icons.tag),
        helperText: 'Separate tags with commas',
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildPreview() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.preview,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            AnimatedBuilder(
              animation: Listenable.merge([
                _titleController,
                _bodyController,
                _tagsController,
              ]),
              builder: (context, child) {
                final tags = _parseTags(_tagsController.text);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_titleController.text.trim().isNotEmpty) ...[
                      Text(
                        _titleController.text.trim(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                    ] else ...[
                      Text(
                        'Your title will appear here...',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],

                    if (_bodyController.text.trim().isNotEmpty) ...[
                      Text(
                        _bodyController.text.trim(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 12),
                    ] else ...[
                      Text(
                        'Your content will appear here...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 12),
                    ],

                    if (tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            tags.map((tag) {
                              return Chip(
                                label: Text(
                                  tag,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                              );
                            }).toList(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
