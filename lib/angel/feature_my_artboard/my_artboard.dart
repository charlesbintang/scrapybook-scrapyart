// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/edit_image_viewmodel_charles.dart';
import 'package:screenshot/screenshot.dart';

class MyArtboard extends StatefulWidget {
  const MyArtboard({Key? key}) : super(key: key);

  @override
  State<MyArtboard> createState() => _MyArtboardState();
}

class _MyArtboardState extends EditImageViewModelCharles {
  final GlobalKey _canvas = GlobalKey();
  String menu = "images";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getCanvasSize());
  }

  getCanvasSize() {
    RenderBox canvasBox =
        _canvas.currentContext!.findRenderObject() as RenderBox;
    setState(() {
      canvasWidth = ((canvasBox.size.width * 50 / 100));
      canvasHeight = ((canvasBox.size.height * 69.4 / 100) / 2);
    });
    print(canvasWidth);
    print(canvasHeight);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(218, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title:
              Text("MyArtboard", style: Theme.of(context).textTheme.titleLarge),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Screenshot(
                  controller: screenshotController,
                  child: Container(
                    key: _canvas,
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 57 / 100,
                    width: MediaQuery.of(context).size.width * 90 / 100,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 25 / 100),
                    child: Stack(
                      children: dataStack(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 25 / 100,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 7 / 100,
                        color: Theme.of(context).primaryColor,
                        child: menusButton(),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 12 / 100,
                        child: switchMenuItems(menu), //switchListView(menu),
                      )
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 150,
              //   right: 0,
              //   left: 0,
              //   child: Container(
              //     color: const Color.fromARGB(255, 122, 74, 37),
              //     height: 40,
              //     child: menusButton(),
              //   ),
              // ),
              // Positioned(
              //   bottom: 200,
              //   right: 0,
              //   left: 0,
              //   child: SizedBox(
              //     height: 40,
              //     child: colorSlider(),
              //   ),
              // ),
              // // Positioned(
              // //   bottom: 100,
              // //   right: 0,
              // //   left: 0,
              // //   child: SizedBox(
              // //     height: 50,
              // //     child: ListView(
              // //       scrollDirection: Axis.horizontal,
              // //       children: [
              // //         IconButton(
              // //           onPressed: () => addNewDialog(context),
              // //           icon: const Icon(
              // //             Icons.add_rounded,
              // //             color: Colors.black,
              // //           ),
              // //         ),
              // //         IconButton(
              // //           onPressed: increaseFontSize,
              // //           icon: const Icon(
              // //             Icons.text_increase_rounded,
              // //             color: Colors.black,
              // //           ),
              // //         ),
              // //         IconButton(
              // //           onPressed: decreaseFontSize,
              // //           icon: const Icon(
              // //             Icons.text_decrease_rounded,
              // //             color: Colors.black,
              // //           ),
              // //         ),
              // //         IconButton(
              // //           onPressed: boldText,
              // //           icon: const Icon(
              // //             Icons.format_bold_rounded,
              // //             color: Colors.black,
              // //           ),
              // //         ),
              // //         IconButton(
              // //           onPressed: italicText,
              // //           icon: const Icon(
              // //             Icons.format_italic_rounded,
              // //             color: Colors.black,
              // //           ),
              // //         ),
              // //         IconButton(
              // //           onPressed: underlineText,
              // //           icon: const Icon(
              // //             Icons.format_underline_rounded,
              // //             color: Colors.black,
              // //           ),
              // //         ),
              // //       ],
              // //     ),
              // //   ),
              // // )
              // Positioned(
              //   bottom: 25,
              //   child: Center(
              //     child: SizedBox(
              //       height: 50,
              //       width: 450,
              //       child: switchListView(menu),

              //       // ListView(
              //       //   scrollDirection: Axis.horizontal,
              //       //   children: [
              //       //     IconButton(
              //       //       onPressed: () => addNewDialog(context),
              //       //       icon: const Icon(
              //       //         Icons.add_rounded,
              //       //         color: Colors.black,
              //       //       ),
              //       //     ),
              //       //     IconButton(
              //       //       onPressed: increaseFontSize,
              //       //       icon: const Icon(
              //       //         Icons.text_increase_rounded,
              //       //         color: Colors.black,
              //       //       ),
              //       //     ),
              //       //     IconButton(
              //       //       onPressed: decreaseFontSize,
              //       //       icon: const Icon(
              //       //         Icons.text_decrease_rounded,
              //       //         color: Colors.black,
              //       //       ),
              //       //     ),
              //       //     IconButton(
              //       //       onPressed: boldText,
              //       //       icon: const Icon(
              //       //         Icons.format_bold_rounded,
              //       //         color: Colors.black,
              //       //       ),
              //       //     ),
              //       //     IconButton(
              //       //       onPressed: italicText,
              //       //       icon: const Icon(
              //       //         Icons.format_italic_rounded,
              //       //         color: Colors.black,
              //       //       ),
              //       //     ),
              //       //     IconButton(
              //       //       onPressed: underlineText,
              //       //       icon: const Icon(
              //       //         Icons.format_underline_rounded,
              //       //         color: Colors.black,
              //       //       ),
              //       //     ),
              //       //   ],
              //       // ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Row menusButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.note_add_outlined,
          ),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.format_paint_outlined,
          ),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.photo,
          ),
          onPressed: () {
            setState(() {
              menu = "images";
            });
          },
        ),
        IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.text_fields_rounded,
          ),
          onPressed: () {
            setState(() {
              menu = "texts";
            });
          },
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.square_outlined,
          ),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.face_retouching_natural_rounded,
          ),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.brush_rounded,
          ),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.layers,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
