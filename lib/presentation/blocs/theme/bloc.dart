import 'package:assignment/presentation/blocs/theme/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;
  static const String themeKey = 'THEME_KEY';

  ThemeCubit(this.sharedPreferences) : super(ThemeState(isDarkMode: false)) {
    _loadTheme();
  }

  void toggleTheme() {
    final newTheme = !state.isDarkMode;
    emit(ThemeState(isDarkMode: newTheme));
    _saveTheme(newTheme);
  }

  void _loadTheme() {
    final isDarkMode = sharedPreferences.getBool(themeKey) ?? false;
    emit(ThemeState(isDarkMode: isDarkMode));
  }

  void _saveTheme(bool isDarkMode) {
    sharedPreferences.setBool(themeKey, isDarkMode);
  }
}
