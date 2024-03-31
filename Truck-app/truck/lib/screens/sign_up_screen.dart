import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';
import 'dart:developer';

import 'package:truck_app/screens/login_screen.dart';
import 'package:truck_app/screens/truck_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  void _navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500), // Adjust the duration as needed
        pageBuilder: (_, __, ___) => const LoginScreen(),
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
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const TruckScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      final email = _emailController.text.toLowerCase();
      final password = _passwordController.text;

      log('Email: $email, Password: $password');
      final bool isExistingUser = HiveClient().userBox.values.cast<User>().any((element) => element.email == email);
      if (!isExistingUser) {
        final User newUser = User(email: email, password: password);
        // To know which is the current logged in User
        HiveClient().currentUserBox.clear();
        HiveClient().currentUserBox.add(newUser);

        HiveClient().userBox.add(newUser);

        HiveClient().orderBox.clear();
        HiveClient().currentCartTruckBox.clear();

        _navigateToTrucksPage(context);
      } else {
        _showSignUpFailedPopup();
      }
    }
  }

  void _showSignUpFailedPopup() {
    AlertDialog alert = AlertDialog(
      title: const Text('Account already exists'),
      content: const Text('Please proceed to login with your account.'),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                   Text("Sign Up",style: TextStyle(
                   fontSize: 50,
                   color: Colors.black,
                   fontWeight: FontWeight.bold
                   ),
                   ),
                    const SizedBox(height: 30),
                    Form(
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(height: 5,),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          ),
                          SizedBox(height: 5,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            const Text("I have account "),
                            const SizedBox(
                              width: 5,
                            ),
                                TextButton(
                                  onPressed: _navigateToLoginPage,
                                  child: const Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
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
