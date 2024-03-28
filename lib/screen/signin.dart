import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:customerapp/reusable/reusable_widget.dart';
import 'package:customerapp/screen/home.dart';
import 'package:customerapp/screen/signup.dart';


class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<SigninScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade800, // Dark Blue
              Colors.lightBlue.shade300,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                logowidget("assets/images/loho.png"),
                SizedBox(height: 30),
                reusableTextField(
                  "Enter Username",
                  
                  Icons.person_outline,
                  false,
                  _emailTextController,
                  Colors.white,
                ),
                SizedBox(height: 30),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                  Colors.white,
                ),
                SizedBox(height: 20),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerScreen(),
                      ),
                    );
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sign-in failed. Please sign up before signing in.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                }),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white60),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ),
            );
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget reusableTextField(
    String hintText,
    IconData icon,
    bool obscureText,
    TextEditingController controller,
     Color textColor,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor), 
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

Color hexStringToColor(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  return Color(int.parse("0xFF$hexColor"));
}
