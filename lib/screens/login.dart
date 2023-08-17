import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:maven_market/screens/dashboard.dart';
import 'package:maven_market/screens/reset_password.dart';
import 'package:maven_market/screens/signup.dart';
import 'package:maven_market/theme.dart';
import 'package:maven_market/widgets/login_form.dart';
import 'package:maven_market/widgets/login_option.dart';
import 'package:maven_market/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../state/AuthState.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  _LogInScreenState createState() => _LogInScreenState();

  }

  class _LogInScreenState extends State<LogInScreen> {

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final FocusNode emailFocus = FocusNode();
    final FocusNode passwordFocus = FocusNode();

    void showAlertDialog(BuildContext context, String label, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(label),
            // title: const Text('Login Error'),
            content: Text(message),
            // content: const Text('Invalid email or password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    void handleLogin(BuildContext context) async {

      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      bool isEmailEmpty = emailController.text.isEmpty;
      bool isPasswordEmpty = passwordController.text.isEmpty;

      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (isEmailEmpty || isPasswordEmpty) {
        // Show error messages for empty fields
        if (isEmailEmpty) {
          showAlertDialog(context, 'Login Error', 'Email field cannot be empty.');
          FocusScope.of(context).requestFocus(emailFocus);
          return;
        }
        if (isPasswordEmpty) {
          showAlertDialog(context, 'Login Error', 'Password field cannot be empty.');
          FocusScope.of(context).requestFocus(passwordFocus);
          return;
        }
        return;
      }

      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        final authState = Provider.of<AuthState>(context, listen: false);
        Navigator.pushNamed(context,'/',arguments: authState);
      } else {
        showAlertDialog(context, 'Login Error', 'Invalid email or password. Please try again.');
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: kDefaultPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 120,
              ),
              Text(
                'Welcome Back',
                style: titleText,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'New to this app?',
                    style: subTitle,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context,'signup/',arguments: null);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const SignUpScreen(),
                      //   ),
                      // );
                    },
                    child: Text(
                      'Sign Up',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              LogInForm(emailController: emailController, passwordController: passwordController),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen()));
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: kZambeziColor,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    handleLogin(context);
                  },
                  child: const PrimaryButton(
                    buttonText: 'Log In',
                  )
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Or log in with:',
                style: subTitle.copyWith(color: kBlackColor),
              ),
              const SizedBox(
                height: 20,
              ),
              const LoginOption(),
            ],
          ),
        ),
      ),
    );
  }
}
