// ignore_for_file: use_build_context_synchronously

// Dart
import 'dart:convert';
// Flutter Packages
import 'package:airsoft/screens/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  bool _isLoading = true, _isLoadingPage = true, _isUserLocal = false, _isPasswordVisible = true;

  final _userFocus = FocusNode(), _passwordFocus = FocusNode();
  final _emailController = TextEditingController(), _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    asyncInit();
  }

  void asyncInit() async {
    _isUserLocal = false;

    setState(() {
      _isLoading = false;
      _isLoadingPage = false;
    });
  }

  void handleLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyPageView(),
        settings: const RouteSettings(name: "home.dart"),
      ),
    );
  }

  void handleBiometryLogin() {}

  void handleForgotPassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: _isUserLocal
              ? Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.45,
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            "Bem-Vindo de Volta!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: handleBiometryLogin,
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey.shade300,
                                child: Text(
                                  "LG",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 14,
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            "Lucca Gabriel",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Escreva Algo Pica",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Icon(
                                Icons.fingerprint,
                                size: 35,
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          child: GestureDetector(
                            onTap: () {
                              _passwordController.clear();
                              _emailController.clear();

                              setState(() {
                                _isUserLocal = !_isUserLocal;
                              });
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.cached),
                                SizedBox(width: 5),
                                Text("Trocar Conta")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: _passwordController,
                        maxLines: 1,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Senha",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            size: 24,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              size: 24,
                            ),
                            onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: MaterialButton(
                        onPressed: handleLogin,
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Entrar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      onPressed: handleForgotPassword,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "Esqueceu sua senha?",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.45,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            "Realizar Login",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: TextFormField(
                            controller: _emailController,
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white,
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white,
                                size: 24,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.black54
                                      : Colors.white,
                                  size: 24,
                                ),
                                onPressed: () async {
                                  _emailController.clear();
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Card(
                      elevation: 2,
                      child: TextFormField(
                        controller: _passwordController,
                        maxLines: 1,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Senha",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            size: 24,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              size: 24,
                            ),
                            onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: MaterialButton(
                        onPressed: handleLogin,
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Entrar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: handleForgotPassword,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "Esqueceu sua senha?",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    MaterialButton(
                      onPressed: () {},
                      height: 40,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      color: Theme.of(context).colorScheme.primary,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "Cadrastrar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
