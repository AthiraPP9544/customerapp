import 'package:customerapp/reusable/reusable_widget.dart';
import 'package:customerapp/screen/home.dart';
import 'package:customerapp/screen/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade800, 
              Colors.lightBlue.shade300,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  logowidget("assets/images/loho.png"),
                  SizedBox(height: 30),
                  reusableTextField(
                    "Enter Username",
                    Icons.person_outline,
                    false,
                    _userNameTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                          textColor: Colors.white, // Pass the desired text color
  iconColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  reusableTextField(
                    "Enter Email Id",
                    Icons.email_outlined,
                    false,
                    
                    _emailTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                          textColor: Colors.white, // Pass the desired text color
  iconColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  reusableTextField(
                    "Enter Password",
                    Icons.lock_outline,
                    true,
                    _passwordTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    textColor: Colors.white, // Pass the desired text color
  iconColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  signInSignUpButton(context, false, () {
                    if (_formKey.currentState!.validate()) {
                      
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                          .then((value) {
                        print("Created new account");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerScreen(),
                          ),
                        );
                      }).onError((error, stackTrace) {
                        print("Error  ${error.toString()}");
                      });
                    }
                  }),
                  signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(email);
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(color: Colors.white60),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SigninScreen(),
              ),
            );
          },
          child: const Text(
            " Sign In",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

Widget reusableTextField(
  String hintText,
  IconData icon,
  bool obscureText,
  
  TextEditingController controller, {
  String? Function(String?)? validator,
  Color? textColor, 
  Color? iconColor,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    style: TextStyle(color: const Color.fromARGB(255, 27, 1, 1)),
    decoration: InputDecoration(
      labelText: hintText,
      prefixIcon: Icon(icon),
    ),
    validator: validator,
  );
}
