// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:scrapyart_home/angel/my_artboard_feature/stack_object_model.dart';
import 'package:scrapyart_home/salisa/ngetemplate/template_board_controller.dart';

import 'package:screenshot/screenshot.dart';

class TemplateBoard extends StatefulWidget {
  // ambil data dengan widget.assetImage
  final double templateHeight;
  final double templateWidth;
  final int placeholder;
  final int id;
  final String assetImage;
  const TemplateBoard({
    Key? key,
    required this.id,
    required this.templateHeight,
    required this.templateWidth,
    required this.placeholder,
    required this.assetImage,
  }) : super(key: key);

  @override
  State<TemplateBoard> createState() => _TemplateBoardState();
}

class _TemplateBoardState extends TemplateBoardController {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(218, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("TemplateBoard",
              style: Theme.of(context).textTheme.titleLarge),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 10 / 100,
                  vertical: MediaQuery.of(context).size.width * 9 / 100,
                ),
                child: Screenshot(
                  controller: screenshotController,
                  child: GestureDetector(
                    onTap: () {
                      for (var i = 0; i < globalListObject.length; i++) {
                        var objectOnCurrentIndex = globalListObject[i];

                        objectOnCurrentIndex.onClicked = OnAction.isFalse;
                      }

                      setState(() {});
                    },
                    onPanStart: (details) => brushOnPanStart(details),
                    onPanUpdate: (details) => brushOnPanUpdate(details),
                    onPanEnd: (details) => brushOnPanEnd(details),
                    child: widget.id == 1
                        ? Container(
                            key: const GlobalObjectKey("utama"),
                            color: canvasColor,
                            height: widget.templateHeight / 4,
                            width: widget.templateWidth / 4,
                            child: Stack(
                              children: dataStack(),
                            ),
                          )
                        : Container(
                            key: const GlobalObjectKey("utama"),
                            color: canvasColor,
                            height: widget.templateHeight / 3,
                            width: widget.templateWidth / 3,
                            child: Stack(
                              children: dataStack(),
                            ),
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
                        child: switchMenuItems(menu),
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
