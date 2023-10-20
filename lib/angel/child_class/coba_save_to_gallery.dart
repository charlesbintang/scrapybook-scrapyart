// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/feature_save_to_gallery/my_save_to_gallery.dart';

class CobaSaveToGallery extends StatelessWidget {
  const CobaSaveToGallery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        // To styling button
        // style: ButtonStyle(
        //     foregroundColor: MaterialStateProperty.resolveWith(
        //         (states) => Colors.white),
        //     backgroundColor: MaterialStateProperty.resolveWith(
        //         (states) => Colors.amber)),
        child: const Text("Coba Fitur Save To Gallery!"),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MySaveToGallery(),
            ),
          );
        },
      ),
    );
  }
}
