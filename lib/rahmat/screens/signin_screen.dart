import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapyart_home/rahmat/reusable_widget/reusable_widget.dart';
import 'package:scrapyart_home/rahmat/screens/home_screen.dart';
import 'package:scrapyart_home/rahmat/screens/signup_screen.dart';
import 'package:scrapyart_home/rahmat/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("lib/assets/logo.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, "LOG IN", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ]),
                ),
                signUpOption(),
                const SizedBox(height: 30),
                logos(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row logos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () async {
              PermissionStatus cameraStatus = await Permission.camera.request();

              if (cameraStatus == PermissionStatus.granted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("This permission is granted.")));
              }
              if (cameraStatus == PermissionStatus.denied) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("This permission is recommened.")));
              }
              if (cameraStatus == PermissionStatus.permanentlyDenied) {
                openAppSettings();
              }
              print("Logo taped");
            },
            child: iconWidget("lib/assets/google_logo.png")),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
