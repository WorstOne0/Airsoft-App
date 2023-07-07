// Dart
import 'dart:async';
// Flutter Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
// Widgets
import '/widgets/my_snackbar.dart';

// (https://pub.dev/packages/connectivity_plus)

@immutable
class ConnectivityState {
  const ConnectivityState({
    required this.connectivityStatus,
  });

  final ConnectivityResult? connectivityStatus;

  ConnectivityState copyWith({
    ConnectivityResult? connectivityStatus,
  }) {
    return ConnectivityState(
      connectivityStatus: connectivityStatus ?? this.connectivityStatus,
    );
  }
}

class ConnectivityController extends StateNotifier<ConnectivityState> {
  ConnectivityController({required this.ref})
      : super(const ConnectivityState(connectivityStatus: null));

  Ref ref;
  // Instance
  Connectivity connectivityInstance = Connectivity();
  //
  StreamSubscription? connectivityStream;

  void initialize() {
    connectivityStream = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      state = state.copyWith(connectivityStatus: result);
    });
  }

  void onlineLogic() {}

  void offlineLogic() async {}
}

// Firebase Messaging Provider
final connectivityServiceProvider =
    StateNotifierProvider<ConnectivityController, ConnectivityState>((ref) {
  //
  return ConnectivityController(ref: ref);
});
