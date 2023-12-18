import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class hom extends StatefulWidget {
  const hom({Key? key}) : super(key: key);

  @override
  _homState createState() => _homState();
}

class _homState extends State<hom> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List<String> imgList = [
    'lib/assets/iklan 1.png',
    'lib/assets/iklan 2.png',
    'lib/assets/iklan 3.png',
    'lib/assets/iklan 4.png',
    'lib/assets/iklan 5.png',
    'lib/assets/iklan 6.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 205, 106),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 10),
                          ),
                          child: const Text('Disable'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 10),
                          ),
                          child: const Text('Enable'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      title: const Text('Akses Semua Fitur Tanpa Iklan'),
                      content: const Text(
                          'Langganan ini memberi Anda akses tanpa batas ke workspace konten aplikasi mobile kami. \n'
                          'Jika Anda tidak membatalkan sebelum coba gratis berakhir, Anda akan secara otomatis  \n'
                          'Rp 119.000,00 setiap tahun hingga Anda membatalkan.\n',
                          style: TextStyle(fontSize: 9)),
                    );
                  },
                );
                // open pro
              },
              icon: Transform.scale(
                scale: 2.1,
                child: Image.asset('assets/images/pro.png'),
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
      body: Column(children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            autoPlay: true,
            aspectRatio: 2.0,
            viewportFraction: 1,
            onPageChanged: (index, carouselReason) {
              print(index);
              setState(() {
                _current = index;
              });
            },
            enlargeCenterPage: true,
          ),
          items: imgList
              .map((item) => Container(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            children: <Widget>[
                              Image.network(item,
                                  fit: BoxFit.cover, width: 1000.0),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 5.0,
                height: 5.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 5),
        Center(
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
                              90, 130, 10, 10), // Adjust margin as needed
                          child: Image.asset(
                            'assets/images/ngescrap.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(height: 0.1), // Space between icon and text
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 90,
                            right: 10,
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
                      // open ngetemplate
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              90, 130, 50, 10), // Adjust margin as needed
                          child: Image.asset(
                            'assets/images/ngetemplate.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(height: 0.1), // Space between icon and text
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 50,
                            right: 10,
                            top: 0.4,
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // open ngeorder
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              90, 40, 10, 10), // Adjust margin as needed
                          child: Image.asset(
                            'assets/images/ngorder.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(height: 0.1), // Space between icon and text
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 90,
                            right: 10,
                            top: 0.1,
                          ), // Adjust text position
                          child: Text(
                            'Ngeorder',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // open gudangku
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              90, 40, 10, 10), // Adjust margin as needed
                          child: Image.asset(
                            'assets/images/gudangku.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(height: 0.1), // Space between icon and text
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 90,
                            right: 10,
                            top: 0.1,
                          ), // Adjust text position
                          child: Text(
                            'Gudangku',
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
        // Spasi antara carousel dan teks
      ]),
      bottomNavigationBar: Container(
        height: 40,
        width: double.infinity, // Set width to fill the parent
        color: Color(0xFF684500), // Background color of the Container
      ),
    );
  }
}

// Function to show the dialog
