// Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Screens
import '/screens/profile/profile.dart';
// Utils
import '/utils/string_extensions.dart';

class MyAppBar extends ConsumerStatefulWidget {
  const MyAppBar({super.key});

  @override
  ConsumerState<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends ConsumerState<MyAppBar> {
  MemoryImage? imagemBase64;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset(
            "assets/images/logo.png",
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Profile(),
                settings: const RouteSettings(name: "profile.dart"),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: Image.asset("assets/images/mota.png").image,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
