import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrapyart_home/rahmat/reusable_widget/reusable_widget.dart';
import 'package:scrapyart_home/rahmat/screens/signin_screen.dart';
import 'package:scrapyart_home/rahmat/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmpasswordTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _NameTextController = TextEditingController();
  final TextEditingController _ProfileTextController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 166, 1),
        elevation: 0,
        title: const Text("Create An Account",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        leading: const BackButton(
          style: ButtonStyle(
              iconColor: MaterialStatePropertyAll(Color(0xFF684500))),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("6845400"),
            hexStringToColor("684540"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 0),
                // name
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Name", Icons.person_outline, false, _NameTextController),
                const SizedBox(height: 10),

                // name
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Username", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(height: 10),

                // email
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Email", Icons.lock_outlined, false, _emailTextController),

                const SizedBox(height: 10),

                // name
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Password", Icons.lock_outlined, true,
                    _passwordTextController),

                const SizedBox(height: 10),

                // confirm password
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                reusableTextField("Confirm Password", Icons.lock_outlined, true,
                    _confirmpasswordTextController),
                const SizedBox(height: 10),

                firebaseUIButton(context, "Sign Up", () async {
                  if (_userNameTextController.text.isNotEmpty &&
                      _emailTextController.text.isNotEmpty &&
                      _passwordTextController.text.isNotEmpty &&
                      _confirmpasswordTextController.text.isNotEmpty) {
                    if (_passwordTextController.text ==
                        _confirmpasswordTextController.text) {
                      // Melanjutkan pendaftaran
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      );

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(userCredential.user!.email)
                          .set({
                        //'username': userNameTextController.text,
                        'username': _emailTextController.text.split('@')[0],
                        'email': _emailTextController.text,
                        'password': _passwordTextController.text,
                        'uid': auth.currentUser!.uid,
                        'createdAt': DateTime.now(),
                        'profile': _ProfileTextController.text,
                      });

                      print("Created New Account");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()),
                      );
                    } else {
                      // Kata sandi dan konfirmasi kata sandi tidak cocok
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text(
                                "Password and Confirm Password do not match."),
                            actions: [
                              TextButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    // Menampilkan pesan kesalahan jika ada bidang yang kosong
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text("Please fill in all fields."),
                          actions: [
                            TextButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }),

                signInOption(),
                const SizedBox(height: 10)
              ],
            ),
          ))),
    );
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?",
            style: TextStyle(color: Color.fromARGB(179, 0, 0, 0))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          },
          child: const Text(
            " Sign In",
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
