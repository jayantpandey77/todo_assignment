import 'package:assignment/app/theme.dart';
import 'package:assignment/presentation/blocs/theme/bloc.dart';
import 'package:assignment/presentation/blocs/theme/state.dart';
import 'package:assignment/presentation/screen/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'User Management App',
          theme: state.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: UserListScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
