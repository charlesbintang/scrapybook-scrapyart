import 'package:scrapyart_home/rahmat/reusable_widget/reusable_widget.dart';
import 'package:scrapyart_home/rahmat/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("6845400"),
            hexStringToColor("684540"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  10, MediaQuery.of(context).size.height * 0.1, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/logo.png"),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Enter Your Email and we will send you a password reset link',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  reusableTextField("Enter Your Email", Icons.person_outline,
                      false, _emailTextController),
                  const SizedBox(
                    height: 10,
                  ),
                  firebaseUIButton(context, "Reset Password", () async {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _emailTextController.text.trim());
                      print("cek email");
                    } on FirebaseAuthException catch (e) {
                      print(e);
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
