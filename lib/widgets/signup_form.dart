import 'package:flutter/material.dart';
import 'package:maven_market/theme.dart';

class SignUpForm extends StatefulWidget {

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController passwordAgainController;

  const SignUpForm({required this.firstNameController, required this.lastNameController, required this.emailController, required this.phoneController, required this.passwordController, required this.passwordAgainController, Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm('First Name', widget.firstNameController , false),
        buildInputForm('Last Name', widget.lastNameController, false),
        buildInputForm('Email', widget.emailController , false),
        buildInputForm('Phone', widget.phoneController, false),
        buildInputForm('Password', widget.passwordController, true),
        buildInputForm('Confirm Password', widget.passwordAgainController, true),
      ],
    );
  }

  Padding buildInputForm(String hint, TextEditingController controller, bool pass) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          controller: controller,
          obscureText: pass ? _isObscure : false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: kTextFieldColor),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),
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
                ))
                : null,
          ),
        ));
  }
}
