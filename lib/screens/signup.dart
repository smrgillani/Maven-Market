import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maven_market/screens/login.dart';
import 'package:maven_market/theme.dart';
import 'package:maven_market/widgets/checkbox.dart';
import 'package:maven_market/widgets/login_option.dart';
import 'package:maven_market/widgets/primary_button.dart';
import 'package:maven_market/widgets/signup_form.dart';
import 'package:provider/provider.dart';

import '../state/AuthState.dart';
import '../state/PostState.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController passwordAgainController = TextEditingController();

    void showAlertDialog(BuildContext context, String label, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(label),
            content: Text(message),
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

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void handleSignUp() async {

      final FocusNode emailFocus = FocusNode();
      final FocusNode passwordFocus = FocusNode();
      final FocusNode firstNameFocus = FocusNode();
      final FocusNode lastNameFocus = FocusNode();
      final FocusNode phoneFocus = FocusNode();
      final FocusNode passwordAgainFocus = FocusNode();

      bool isEmailEmpty = emailController.text.isEmpty;
      bool isPasswordEmpty = passwordController.text.isEmpty;
      bool isFirstNameEmpty = firstNameController.text.isEmpty;
      bool isLastNameEmpty = lastNameController.text.isEmpty;
      bool isPhoneEmpty = phoneController.text.isEmpty;
      bool isPasswordAgainEmpty = passwordAgainController.text.isEmpty;

      if (isEmailEmpty || isPasswordEmpty || isFirstNameEmpty || isLastNameEmpty || isPhoneEmpty || isPasswordAgainEmpty) {
        // Show error messages for empty fields
        if (isEmailEmpty) {
          showAlertDialog(context, 'Error', 'Email field cannot be empty.');
          FocusScope.of(context).requestFocus(emailFocus);
          return;
        }
        if (isPasswordEmpty) {
          showAlertDialog(context, 'Error', 'Password field cannot be empty.');
          FocusScope.of(context).requestFocus(passwordFocus);
          return;
        }
        if (isFirstNameEmpty) {
          showAlertDialog(context, 'Error', 'First name field cannot be empty.');
          FocusScope.of(context).requestFocus(firstNameFocus);
          return;
        }
        if (isLastNameEmpty) {
          showAlertDialog(context, 'Error', 'Last name field cannot be empty.');
          FocusScope.of(context).requestFocus(lastNameFocus);
          return;
        }
        if (isPhoneEmpty) {
          showAlertDialog(context, 'Error', 'Phone field cannot be empty.');
          FocusScope.of(context).requestFocus(phoneFocus);
          return;
        }
        if (isPasswordAgainEmpty) {
          showAlertDialog(context, 'Error', 'Please re-enter your password.');
          FocusScope.of(context).requestFocus(passwordAgainFocus);
          return;
        }
        // If any field is empty, return to prevent further processing
        return;
      }

      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        context.read<PostState>().addUserProfile(firstNameController.text.trim(), lastNameController.text.trim(), phoneController.text.trim());

        if (userCredential != null) {

          try {
            UserCredential userCredential = await firebaseAuth
                .signInWithEmailAndPassword(
              email: email,
              password: password,
            );

            final authState = Provider.of<AuthState>(context, listen: false);
            if (userCredential != null) {
              Navigator.pushNamed(context, '/', arguments: authState);
            } else {
              Navigator.pushNamed(context, '/', arguments: authState);
            }

          }catch(e){
            final authState = Provider.of<AuthState>(context, listen: false);
            Navigator.pushNamed(context, '/', arguments: authState);
          }

        } else {
          // Login failed, show an error message
          showAlertDialog(context, 'Error', 'Unable to create user, try again.');
        }
      }catch (e) {
        showAlertDialog(context, 'Error', '$e');
        return null;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Create Account',
                style: titleText,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Row(
                children: [
                  Text(
                    'Already a member?',
                    style: subTitle,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogInScreen()));
                    },
                    child: Text(
                      'Log In',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: kDefaultPadding,
              child: SignUpForm(firstNameController: firstNameController, lastNameController: lastNameController, emailController: emailController, phoneController: phoneController, passwordController: passwordController, passwordAgainController: passwordAgainController),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: kDefaultPadding,
              child: CheckBox('Agree to terms and conditions.'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: kDefaultPadding,
              child: CheckBox('I have at least 18 years old.'),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                handleSignUp();
              },
              child: const Padding(
                padding: kDefaultPadding,
                child: PrimaryButton(buttonText: 'Sign Up'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Or log in with:',
                style: subTitle.copyWith(color: kBlackColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: kDefaultPadding,
              child: LoginOption(),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
