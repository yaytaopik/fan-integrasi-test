import 'package:fantest/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/color_utils.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  @override
  void dispose() {
    _userNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    super.dispose();
  }

  // Future signUp() async {
  //   if (passwordConfirmed()) {
  //     await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: _emailTextController.text,
  //             password: _passwordTextController.text)
  //         .then((value) {
  //       print("Created new account");
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //     });
  //   }
  // }

  Future addUserDetails(String userName, String email) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add({'user name': userName, 'email': email});
  }

  bool passwordConfirmed() {
    if (_passwordTextController.text.trim() ==
        _confirmPasswordTextController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200,
                child: Lottie.asset('assets/38435-register.json',
                    repeat: true, reverse: false, animate: true),
              ),
              SizedBox(height: 50),
              reusableTextField("Enter Username", Icons.person_outline, false,
                  _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "Enter Email", Icons.mail, false, _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  "Password", Icons.password, true, _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Confirm Password", Icons.password, true,
                  _confirmPasswordTextController),
              const SizedBox(
                height: 20,
              ),
              signInSignUpButton(context, false, () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  print("Created new account");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                  addUserDetails(
                      _userNameTextController.text, _emailTextController.text);
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}");
                });
              })
            ],
          ),
        )),
      ),
    );
  }
}
