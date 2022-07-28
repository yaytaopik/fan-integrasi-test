import 'package:fantest/screens/signin_screen.dart';
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
  final _formKey = GlobalKey<FormState>();

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

  // verify function
  void verifyEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    //check if user is not verified
    if (!(user!.emailVerified)) {
      user.sendEmailVerification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("FADBD8"),
            hexStringToColor("F8F9F9"),
            hexStringToColor("FEF5E7")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: Lottie.asset('assets/38435-register.json',
                      repeat: true, reverse: false, animate: true),
                ),
                SizedBox(height: 50),
                TextFormField(
                  controller: _userNameTextController,
                  style: TextStyle(color: Colors.black),
                  obscureText: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'User Name',
                    fillColor: Colors.grey,
                    focusColor: Colors.grey,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Can't be empty!";
                    } else if (value != null && value.length < 3) {
                      return "Value minimum 3 Characters";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailTextController,
                  style: TextStyle(color: Colors.black),
                  obscureText: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    fillColor: Colors.grey,
                    focusColor: Colors.grey,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Can't be empty!";
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return "Enter correct email!";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordTextController,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'password',
                    fillColor: Colors.grey,
                    focusColor: Colors.grey,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    if (value != null && value.length < 8) {
                      return 'Enter min 8 characters';
                    } else if (value!.isEmpty) {
                      return "Can't be empty!";
                    } else if (!regex.hasMatch(value)) {
                      return "Password must have number and character";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordTextController,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'password',
                    fillColor: Colors.grey,
                    focusColor: Colors.grey,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    if (value != null && value.length < 8) {
                      return 'Enter min 8 characters';
                    } else if (value!.isEmpty) {
                      return "Can't be empty!";
                    } else if (!regex.hasMatch(value)) {
                      return "Password must have number and character";
                    } else {
                      return null;
                    }
                  },
                ),
                // reusableTextField("Confirm Password", Icons.password, true,
                //     _confirmPasswordTextController),
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
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomeScreen()));
                    addUserDetails(_userNameTextController.text,
                        _emailTextController.text);
                    verifyEmail();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text("Verify your account"),
                          content: new Text(
                              "Verification link has been sent toyour email, Please verify your email!"),
                          actions: <Widget>[
                            new TextButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInScreen()));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ),
        )),
      ),
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'Email address is required';
  return null;
}
