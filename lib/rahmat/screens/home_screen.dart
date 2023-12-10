import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapyart_home/rahmat/screens/signin_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Logout"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()));
            });
          },
        ),
      ),
    );
  }
}
