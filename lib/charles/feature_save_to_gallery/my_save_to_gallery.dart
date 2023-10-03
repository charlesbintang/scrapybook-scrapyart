// ignore_for_file: unused_import, use_build_context_synchronously

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class MySaveToGallery extends StatefulWidget {
  const MySaveToGallery({super.key});

  @override
  State<MySaveToGallery> createState() => _MySaveToGalleryState();
}

class _MySaveToGalleryState extends State<MySaveToGallery> {
  bool showButton = true;
  // String url = 'https://picsum.photos/id/25/5000/3333';
  // String url = 'https://picsum.photos/id/18/2500/1667';
  // String url = 'https://picsum.photos/id/2/5000/3333';
  // String url = 'https://picsum.photos/id/1/5000/3333';
  String url = 'https://picsum.photos/id/0/5000/3333';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        // Here we take the value from the MyApp object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Save To Gallery",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20),
              child: Image.network(
                url,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    // Setelah foto berhasil dimuat, tampilkan tombol setelah 1 detik.
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            if (showButton)
              Container(
                margin: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () async {
                    // String url = 'https://picsum.photos/250?image=9';
                    final tempDir = await getTemporaryDirectory();
                    final path = '${tempDir.path}/image.jpg';

                    await Dio().download(url, path);
                    await GallerySaver.saveImage(path);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Download to Gallery!")));
                  },
                  style: const ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(Colors.amber),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    padding: MaterialStatePropertyAll(EdgeInsets.all(15)),
                  ),
                  child: const Text("DOWNLOAD THE IMAGE",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
