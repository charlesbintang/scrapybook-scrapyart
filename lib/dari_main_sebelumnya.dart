import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF684500),
          elevation: 0,
          title: Text('HOME'),
          leading: IconButton(
            onPressed: () {
              // open menu
            },
            icon: Icon(Icons.menu),
          ),
          actions: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: () {
                  // open pro
                },
                icon: Transform.scale(
                  scale: 2.1,
                  child: Image.asset('lib/assets/pro.png'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: () {
                  // open person
                },
                icon: Icon(Icons.person),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: 40,
          width: double.infinity, // Set width to fill the parent
          color: Color(0xFF684500), // Background color of the Container
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // open ngescrap
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0, 400, 180, 10), // Adjust margin as needed
                          child: Image.asset(
                            'lib/assets/ngescrap.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(height: 5), // Space between icon and text
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 180,
                            top: 0.1,
                          ), // Adjust text position
                          child: Text(
                            'Ngescrap',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // open ngescrap
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0, 400, 180, 10), // Adjust margin as needed
                          child: Image.asset(
                            'lib/assets/ngetemplate.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(height: 5), // Space between icon and text
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 180,
                            top: 0.1,
                          ), // Adjust text position
                          child: Text(
                            'Ngetemplate',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
