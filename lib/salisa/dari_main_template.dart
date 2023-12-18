import 'package:flutter/material.dart';


import 'product_list_page.dart';


void main() {

  runApp(const MyApp());

}


class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Chip Filter',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(primaryColor: const Color.fromARGB(255, 146, 87, 65)),

      home: const NgeTemplate(),

    );

  }

}

