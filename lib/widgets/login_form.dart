import 'package:flutter/material.dart';
import 'package:maven_market/theme.dart';

class LogInForm extends StatefulWidget {

  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LogInForm({required this.emailController, required this.passwordController, Key? key}) : super(key: key);

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm('Email',widget.emailController, false),
        buildInputForm('Password', widget.passwordController, true),
      ],
    );
  }

  Padding buildInputForm(String label, TextEditingController controller, bool pass) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: pass ? _isObscure : false,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: kTextFieldColor,
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            suffixIcon: pass
                ? IconButton(
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              icon: _isObscure
                  ? const Icon(
                Icons.visibility_off,
                color: kTextFieldColor,
              )
                  : const Icon(
                Icons.visibility,
                color: kPrimaryColor,
              ),
            )
                : null),
      ),
    );
  }
}
