import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import "package:get/get.dart";
import 'package:local_auth/local_auth.dart';

// import 'package:local_auth/local_auth.dart';

class MainController extends GetxController {
  final supportState = _SupportState.unknown.obs;
  final authorized = ''.obs;
  final canCheckBiometrics = false.obs;
  final LocalAuthentication auth = Get.find();
  final availableBiometrics = <BiometricType>[].obs;
  final isAuthenticating = false.obs;

  @override
  void onInit() async {
    super.onInit();

    bool isSupported = false;
    // isSupported = await auth.isDeviceSupported();
    WidgetsFlutterBinding.ensureInitialized();
    isSupported = await auth.isDeviceSupported();
    supportState.value =
        isSupported ? _SupportState.supported : _SupportState.unsupported;
  }

  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
    isAuthenticating.value = false;
  }

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      isAuthenticating.value = true;
      authorized.value = 'Authenticating';
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      isAuthenticating.value = false;
      // setState(() {
      //   _isAuthenticating = false;
      // });
    } on PlatformException catch (e) {
      print(e);
      // setState(() {
      //   _isAuthenticating = false;
      //   _authorized = 'Error - ${e.message}';
      // });
      isAuthenticating.value = false;
      authorized.value = 'Error - ${e.message}';
      return;
    }
    // if (!mounted) {
    //   return;
    // }

    authorized.value = authenticated ? 'Authorized' : 'Not Authorized';
    // setState(
    //         () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      isAuthenticating.value = true;
      authorized.value = 'Authenticating';
      // setState(() {
      //   _isAuthenticating = true;
      //   _authorized = 'Authenticating';
      // });
      authenticated = await auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      isAuthenticating.value = false;
      authorized.value = 'Authenticating';
      // setState(() {
      //   _isAuthenticating = false;
      //   _authorized = 'Authenticating';
      // });
    } on PlatformException catch (e) {
      print(e);
      isAuthenticating.value = false;
      authorized.value = 'Error - ${e.message}';
      // setState(() {
      //   _isAuthenticating = false;
      //   _authorized = 'Error - ${e.message}';
      // });
      return;
    }
    // if (!mounted) {
    //   return;
    // }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    authorized.value = message;
    // setState(() {
    //   _authorized = message;
    // });
  }

  Future<void> checkBiometrics() async {
    bool canCheckBiometrics1;
    try {
      print('#########${await auth.canCheckBiometrics}');
      canCheckBiometrics1 = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics1 = false;
      print(e);
    }

    //mounted 확인하기
    // if (!mounted) {
    //   return;
    // }

    canCheckBiometrics.value = canCheckBiometrics1;
  }

  Future<void> getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics1;
    try {
      availableBiometrics1 = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics1 = <BiometricType>[];
      print(e);
    }

    //monted 확인
    // if (!mounted) {
    //   return;
    // }

    // setState(() {
    //   _availableBiometrics = availableBiometrics;
    // });

    availableBiometrics.clear();
    availableBiometrics.addAll(availableBiometrics1);
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
