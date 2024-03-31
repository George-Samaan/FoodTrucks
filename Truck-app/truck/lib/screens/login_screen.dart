import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/screens/sign_up_screen.dart';
import 'package:truck_app/screens/truck_screen.dart';

import '../models/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _validateEmail(String? email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.\-]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (email == null || email.trim().isEmpty == true) {
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.trim().isEmpty == true) {
      return 'Password cannot be empty';
    }

    return null;
  }

  void _navigateToSignupPage() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500), // Adjust the duration as needed
        pageBuilder: (_, __, ___) => SignupScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
          (route) => false,
    );
  }


  void _navigateToTrucksPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const TruckScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
          (route) => false,
    );
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      final email = _emailController.text.toLowerCase();
      final password = _passwordController.text;

      try {
        log(HiveClient().userBox.values.toString());
        log('email: $email, password: $password');
        final User user = HiveClient()
            .userBox
            .values
            .cast<User>()
            .firstWhere((element) => element.email == email);
        if (user.password == password) {
          final User user = User(email: email, password: password);
          await clearDataIfDifferentUser(user);
          await HiveClient().currentUserBox.add(user);
          log('${HiveClient().currentUserBox.values}');
          _navigateToTrucksPage(context);
        } else {
          _showLoginFailedPopup();
        }
      } catch (e) {
        _showLoginFailedPopup();
        log('show failure');
      }
    }
  }

  Future<void> clearDataIfDifferentUser(User user) async {
    try {
      log('currentUser: ${HiveClient().currentUserBox.values}');
      final User? lastLoggedInUser =
          HiveClient().currentUserBox.values.firstOrNull as User?;
      // clear data if it's not the last logged in user
      if (lastLoggedInUser != null && lastLoggedInUser.email != user.email) {
        log('different user logging in, emptying the db');
        await HiveClient().orderBox.clear();
        await HiveClient().currentUserBox.clear();
        await HiveClient().currentCartTruckBox.clear();
      }
    } catch (e) {
      log('throwing exception at: clearDataIfDifferentUser');
    }
  }

  void _showLoginFailedPopup() {
    AlertDialog alert = AlertDialog(
      title: const Text('Invalid email or password'),
      content: const Text('Please verify your username and password'),
      actions: [
        ElevatedButton(
          onPressed: _dismissAlert,
          child: const Text('OK'),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  void _dismissAlert() {
    Navigator.of(context).maybePop();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Image.asset("assets/Images/testBg0.jpg"
            ,width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text("Log In",style: TextStyle(
                        fontSize: 50,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              labelText: 'E-mail',
                            ),
                            validator: (email) => _validateEmail(email),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isPasswordVisible,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: _togglePasswordVisibility,
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (password) => _validatePassword(password),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center, children: [
                            const Text("I don\'t have acount"),
                            const SizedBox(
                              width: 5,
                            ),
                            TextButton(
                              onPressed: _navigateToSignupPage,
                              child: const Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
