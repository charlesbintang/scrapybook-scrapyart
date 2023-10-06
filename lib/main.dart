import 'package:flutter/material.dart';
import 'package:scrapyart_home/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrapy Art',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(iconColor: MaterialStatePropertyAll(Colors.white)),
        ),
        primaryColor: const Color(0xFF684500),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
