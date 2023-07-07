// Flutter Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class MyBiometry {
  // Local Auth
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> biometricAccess({String? reason}) async {
    final bool canAuthenticateWithBiometrics = await _localAuthentication.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await _localAuthentication.isDeviceSupported();

    if (!canAuthenticate) return false;

    bool success = await _localAuthentication.authenticate(
        localizedReason: reason ?? "",
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true));

    return success;
  }
}

final biometryProvider = Provider<MyBiometry>((ref) => MyBiometry());
