// ignore_for_file: use_build_context_synchronously

// Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Screens
import 'login.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    asyncInit();
  }

  void asyncInit() async {
    // After durations time changes page
    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
        settings: const RouteSettings(
          name: "login.dart",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          // image: DecorationImage(
          //   image: AssetImage(
          //     Theme.of(context).brightness == Brightness.light
          //         ? "assets/drawable/ic_background_white.png"
          //         : "assets/drawable/ic_background_black.jpg",
          //   ),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 0.7,
                child: Image.asset(
                  height: 180,
                  "assets/images/logo.png",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
