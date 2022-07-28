import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantest/read_data/get_user_name.dart';
import 'package:fantest/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/color_utils.dart';
import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  List<String> docIDs = [];
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  // Future getUsersVer() async {
  //   await FirebaseAuth.instance.use
  // }
  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("FADBD8"),
                hexStringToColor("F8F9F9"),
                hexStringToColor("FEF5E7")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Lottie.asset('assets/81252-hello.json',
                        repeat: true, reverse: false, animate: true),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Hello " + user.email!,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  user.emailVerified
                      ? Text(
                          'Email verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.green),
                        )
                      : Text(
                          'Email not verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.red),
                        ),
                  SizedBox(height: 20),
                  MaterialButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        });
                      },
                      color: Colors.blueGrey,
                      child: Text(
                        "Sign out",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
              child: FutureBuilder(
            future: getDocId(),
            builder: ((context, snapshot) {
              return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        title: GetUserName(documentId: docIDs[index]),
                        tileColor: Colors.blueGrey.shade300,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        leading: Icon(Icons.person),
                      ),
                    );
                  });
            }),
          ))
        ],
      )),
    );
  }
}
