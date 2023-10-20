// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/my_artboard.dart';

class CobaArtboard extends StatelessWidget {
  const CobaArtboard({
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
        child: const Text("Coba Fitur Artboard!"),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MyArtboard(),
            ),
          );
        },
      ),
    );
  }
}
