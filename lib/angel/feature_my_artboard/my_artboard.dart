// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/image_text_controller.dart';
import 'package:screenshot/screenshot.dart';

class MyArtboard extends StatefulWidget {
  const MyArtboard({Key? key}) : super(key: key);

  @override
  State<MyArtboard> createState() => _MyArtboardState();
}

class _MyArtboardState extends ImageTextController {
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
                        height: MediaQuery.of(context).size.height * 15 / 100,
                        child: switchMenuItems(menu), //switchListView(menu),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
