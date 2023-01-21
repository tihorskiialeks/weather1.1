part of 'theme_provider.dart';

enum AppTheme { light, dark }

class ThemeState extends Equatable {
  final AppTheme appTheme;

  ThemeState({this.appTheme = AppTheme.light});

  factory ThemeState.initial(){
    return ThemeState(appTheme: AppTheme.light);
  }

  @override
  List<Object?> get props => [appTheme];

  @override
  bool get stringify {
    return true;
  }

  ThemeState copyWith({AppTheme? appTheme}) {
    return ThemeState(appTheme: appTheme ?? this.appTheme);
  }
}
