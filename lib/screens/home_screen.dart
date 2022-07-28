import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantest/read_data/get_user_name.dart';
import 'package:fantest/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/color_utils.dart';
import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  //gathering all users data
  List<String> docIDs = [];

  // get doc ID
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  @override
  void initState() {
    getDocId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.email!,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(colors: [
          //     hexStringToColor("FFFFFF"),
          //     hexStringToColor("9546C4"),
          //     hexStringToColor("5E61F4")
          //   ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text(
              //   "Signed in as: " + user.email!,
              //   style: TextStyle(color: Colors.white, fontSize: 20),
              // ),
              // SizedBox(height: 30),
              // ElevatedButton(
              //     onPressed: () {
              //       FirebaseAuth.instance.signOut().then((value) {
              //         print("Signed Out");
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => SignInScreen()));
              //       });
              //     },
              //     child: Text("Logout")),
              SizedBox(height: 30),
              Expanded(
                  child: FutureBuilder(
                      future: getDocId(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: docIDs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: GetUserName(
                                  documentId: docIDs[index],
                                ),
                                tileColor: Colors.grey,
                              ),
                            );
                          },
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
