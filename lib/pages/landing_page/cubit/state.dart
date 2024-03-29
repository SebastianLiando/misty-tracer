import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class LandingPageState with _$LandingPageState {
  const factory LandingPageState({
    @Default("") String ip,
    @Default("") String port,
    @Default(null) String? previousIp,
    @Default(null) int? previousPort,
    @Default(false) bool skipTutorial,
    @Default(0) int stepperIndex,
    @Default(false) bool isConnecting,
  }) = _LandingPageState;
}

extension LandingPageStateExt on LandingPageState {
  int get portNumber => int.parse(port);

  bool get showFooter => stepperIndex == 2;

  String? get ipError {
    if (ip.isNotEmpty && !ip.isIpV4) return "Invalid IPv4 address!";
    return null;
  }

  String? get portError {
    if (port.isNotEmpty && !port.isPortNumber) return "Invalid port number!";
    return null;
  }

  bool get hasPreviousSession => previousIp != null && previousPort != null;

  bool get canConnectToServer => ip.isIpV4 && port.isPortNumber;
}

extension StringExt on String {
  bool get isIpV4 => RegExp(
          r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')
      .hasMatch(this);

  bool get isPortNumber {
    final parsed = int.tryParse(this);

    return parsed != null && parsed <= 65535;
  }
}
