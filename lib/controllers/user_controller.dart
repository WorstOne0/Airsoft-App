// Dart
import 'dart:async';
import 'dart:convert';
// Flutter Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// Controller
import '/controllers/firebase_controller.dart';
// Models
import '/models/user.dart';
// Services
import '/services/dio_provider.dart';
import '/services/hive_storage.dart';
import '/services/secure_storage.dart';
import '/services/biometry_service.dart';

// My Controller are a mix between the Controller and Repository from the
// Riverpod Architecture (https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/).
// It handles the management of the widget state. (Riverpod Controller's job)
// It handles the data parsing and serialilzation from api's. (Riverpod Repository's job).

// Using StateNotifier, maybe consider changing to AsyncNotifier
// PROBLEM: handles the AsyncData values inside and outside the provider.
// (AsyncNotifier >> StateNotifier, on theory, little documentation)

@immutable
class UserState {
  const UserState({
    required this.user,
  });

  final User? user;

  UserState copyWith({User? user}) {
    return UserState(
      user: user ?? this.user,
    );
  }
}

class UserController extends StateNotifier<UserState> {
  UserController({required this.ref, required this.dioProvider, required this.hiveStorage})
      : super(const UserState(user: null));

  Ref ref;
  // Dio
  DioProvider dioProvider;
  // Persist Data
  SecureStorage storage = SecureStorage();
  HiveStorage hiveStorage;
  // Token Timer
  Timer? tokenTimer;
  bool timerAwait = false;

  // User Authentication
  Future<bool> isLogged() async {
    return false;
  }

  Future<bool> biometryLogin() async {
    // Try to do the biometry
    bool success = await validateBiometrics();
    if (!success) return false;

    // If is successful retrive the user and password stored
    String? email = await storage.readString("username"),
        password = await storage.readString("password");

    if (password == null) return false;

    Map<String, String> data = {"usuario": email ?? "", "senha": password, "origem": "mobile"};

    bool loginSuccess = await login(data);

    return loginSuccess;
  }

  Future<bool> validateBiometrics() async {
    try {
      // See if the user wants to use biometrics
      String? useBiometrics = await storage.readString("use-auth-biometrics");

      // User first login OR user dont want biometrics
      if (useBiometrics == null || useBiometrics == "false") return false;

      // Try to do the biometry
      bool success =
          await ref.read(biometryProvider).biometricAccess(reason: "Autenticação necessaria");

      return success;
    } catch (error) {
      // All errors except Dio Error

      return false;
    }
  }

  Future<bool> login(Map<String, String> data) async {
    String? firebaseToken;

    try {
      firebaseToken = await ref.read(firebaseMessagingProvider.notifier).getDeviceToken();
    } catch (error) {
      firebaseToken = "";
    }

    // Send data to the backend
    try {
      // Get user, and authorization token
      Response res =
          await dioProvider.dio.post("/login", data: {...data, "fcmToken": firebaseToken});

      // Save the token, user and password
      String token = res.data["authorizationToken"];
      storage.saveString("authorizationToken", token);

      storage.saveString("username", data["usuario"] ?? "");
      storage.saveString("password", data["senha"] ?? "");

      // Create User
      User myUser = User.fromJson(res.data);

      // Save User to LocalStorage
      storage.saveString("user", jsonEncode(myUser.toJson()));

      // Firebase Analytics set User
      FirebaseAnalytics.instance.setUserId(id: state.user?.id.toString() ?? "");
      // Firebase Crashlytics set User
      FirebaseCrashlytics.instance.setUserIdentifier(state.user?.id.toString() ?? "");

      state = state.copyWith(user: myUser);
      return true;
    } on DioException {
      return false;
    } catch (error) {
      return false;
    }
  }

  void logout() {
    tokenTimer?.cancel();
    state = state.copyWith(user: null);

    storage.deleteKey("authorizationToken");
    storage.deleteKey("user");
    storage.deleteKey("password");
    //
    storage.deleteKey("use-auth-biometrics");
  }
}

final userProvider = StateNotifierProvider<UserController, UserState>((ref) {
  return UserController(
    ref: ref,
    dioProvider: ref.watch(dioProvider),
    hiveStorage: ref.watch(hiveStorageProvider),
  );
});
