import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  final File image;
  final String date;

  const PhotoScreen({super.key, required this.image, required this.date});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          date,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<ImageInfo>(
        future: _getImageInfo(image),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final info = snapshot.data!;
          final ratio = info.image.width / info.image.height;

          return Center(
            child: AspectRatio(
              aspectRatio: ratio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image, fit: BoxFit.contain),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<ImageInfo> _getImageInfo(File file) async {
  final completer = Completer<ImageInfo>();
  final image = FileImage(file);
  image
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((info, _) => completer.complete(info)));
  return completer.future;
}
