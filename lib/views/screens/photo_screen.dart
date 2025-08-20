import 'dart:io' show File;

import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  final File? image;
  final String? imageUrl;
  final String date;

  const PhotoScreen({super.key, this.image, this.imageUrl, required this.date});

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
      body: _buildImageBody(),
    );
  }

  Widget _buildImageBody() {
    if (image != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(image!, fit: BoxFit.contain),
        ),
      );
    }
    if (imageUrl != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(imageUrl!, fit: BoxFit.contain),
        ),
      );
    } else {
      return const Center(child: Icon(Icons.image_not_supported, size: 64));
    }
  }
}
