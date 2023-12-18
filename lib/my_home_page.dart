import 'package:flutter/material.dart';


import 'package:carousel_slider/carousel_slider.dart';


import 'package:scrapyart_home/angel/my_artboard_feature/my_artboard.dart';


import 'package:scrapyart_home/rahmat/screens/gudangku.dart';


import 'package:url_launcher/url_launcher.dart';


class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});


  @override

  State<MyHomePage> createState() => _MyHomePageState();

}


class _MyHomePageState extends State<MyHomePage> {

  int _current = 0;


  final CarouselController _controller = CarouselController();


  final webGform = Uri.parse(

      'https://docs.google.com/forms/d/e/1FAIpQLSegm8cSPt1vqP_XOnmgir6Q6tKIMua3kgeQVrM0_UE0T8nukg/viewform?usp=sf_link');


  final List<String> imgList = [

    'lib/assets/iklan1.png',

    'lib/assets/iklan2.png',

    'lib/assets/iklan3.png',

    'lib/assets/iklan4.png',

    'lib/assets/iklan5.png',

    'lib/assets/iklan6.png'

  ];


  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Aplikasi Scrapy Art',

      home: Scaffold(

        appBar: AppBar(

          // backgroundColor: const Color(0xFF684500),


          backgroundColor: Theme.of(context).primaryColor,


          elevation: 0,


          title: Text(

            'HOME',

            style: Theme.of(context).textTheme.titleLarge,

          ),


          leading: IconButton(

            style: Theme.of(context).iconButtonTheme.style,

            onPressed: () {

              // open menu

            },

            icon: const Icon(Icons.menu),

          ),


          actions: [

            Container(

              padding: const EdgeInsets.all(10.0),

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

              padding: const EdgeInsets.all(10.0),

              child: IconButton(

                onPressed: () {

                  // open person

                },

                icon: const Icon(Icons.person),

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

                setState(() {

                  _current = index;

                });

              },

              enlargeCenterPage: true,

            ),

            items: imgList

                .map((item) => Container(

                      margin: const EdgeInsets.all(5.0),

                      child: ClipRRect(

                          borderRadius:

                              const BorderRadius.all(Radius.circular(5.0)),

                          child: Stack(

                            children: <Widget>[

                              Image.asset(item,

                                  fit: BoxFit.cover, width: 1000.0),

                              Positioned(

                                bottom: 0.0,

                                left: 0.0,

                                right: 0.0,

                                child: Container(

                                  decoration: const BoxDecoration(

                                    gradient: LinearGradient(

                                      colors: [

                                        Color.fromARGB(200, 0, 0, 0),

                                        Color.fromARGB(0, 0, 0, 0)

                                      ],

                                      begin: Alignment.bottomCenter,

                                      end: Alignment.topCenter,

                                    ),

                                  ),

                                  padding: const EdgeInsets.symmetric(

                                      vertical: 10.0, horizontal: 20.0),

                                ),

                              ),

                            ],

                          )),

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

                  margin: const EdgeInsets.symmetric(

                      vertical: 8.0, horizontal: 4.0),

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


          // const SizedBox(height: 5),


          const Expanded(child: SizedBox()),


          Center(

            child: SizedBox(

              width: 250,

              child: Wrap(

                alignment: WrapAlignment.center,

                spacing: 60,

                runSpacing: 60,

                children: [

                  GestureDetector(

                    onTap: () {

                      // open ngescrap


                      Navigator.of(context).push(

                        MaterialPageRoute(

                          builder: (context) => const MyArtboard(),

                        ),

                      );

                    },

                    child: Container(

                      padding: const EdgeInsets.symmetric(horizontal: 10),

                      child: Column(

                        children: [

                          Image.asset(

                            'lib/assets/ngescrap.png',

                            width: 40,

                            height: 40,

                          ),


                          const SizedBox(

                              height: 3), // Space between icon and text


                          const Text("Ngescrap"),

                        ],

                      ),

                    ),

                  ),

                  GestureDetector(

                    onTap: () {

                      // open ngetemplate

                    },

                    child: Column(

                      children: [

                        Image.asset(

                          'lib/assets/ngetemplate.png',

                          width: 40,

                          height: 40,

                        ),


                        const SizedBox(

                            height: 3), // Space between icon and text


                        const Text("Ngetemplate"),

                      ],

                    ),

                  ),

                  GestureDetector(

                    // open ngeorder ke gform pemesanan


                    onTap: () => setState(() {

                      launchUrl(

                        webGform,

                        mode: LaunchMode.externalApplication,

                      );

                    }),


                    child: Container(

                      padding: const EdgeInsets.symmetric(horizontal: 11),

                      child: Column(

                        children: [

                          Image.asset(

                            'lib/assets/ngorder.png',

                            width: 40,

                            height: 40,

                          ),


                          const SizedBox(

                              height: 3), // Space between icon and text


                          const Text("Ngeorder"),

                        ],

                      ),

                    ),

                  ),

                  GestureDetector(

                    onTap: () {

                      // open gudangku


                      Navigator.of(context).push(

                        MaterialPageRoute(

                          builder: (context) => const GudangkuScreen(),

                        ),

                      );

                    },

                    child: Container(

                      padding: const EdgeInsets.symmetric(horizontal: 9),

                      child: Column(

                        children: [

                          Image.asset(

                            'lib/assets/gudangku.png',

                            width: 40,

                            height: 40,

                          ),


                          const SizedBox(

                              height: 3), // Space between icon and text


                          const Text("Gudangku"),

                        ],

                      ),

                    ),

                  ),

                ],

              ),

            ),

          ),


          const Expanded(child: SizedBox()),


          // Spasi antara carousel dan teks

        ]),

        bottomNavigationBar: Container(

          height: 40,


          width: double.infinity, // Set width to fill the parent


          color: const Color(0xFF684500), // Background color of the Container

        ),

      ),

    );

  }

}

