part of 'temp_settings_provider.dart';

enum TempUnit { celsius, fahrenheit }

class TempSettingsState extends Equatable {
  final TempUnit tempUnit;

  const TempSettingsState({this.tempUnit = TempUnit.celsius});

  @override
  List<Object?> get props => [tempUnit];

  @override
  bool get stringify => true;

  TempSettingsState copyWith({TempUnit? tempUnit}) =>
      TempSettingsState(tempUnit: tempUnit ?? this.tempUnit);
}
