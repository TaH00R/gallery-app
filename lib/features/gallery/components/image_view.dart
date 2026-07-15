import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  final Future<File?> imageFile;
  const ImageView({super.key, required this.imageFile});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : Colors.black,
      body: FutureBuilder<File>(
        future: imageFile.then((value) => value!),
        builder: (_,snapshot){
          final file = snapshot.data;
          if(file == null){
            return Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return PhotoView(
            imageProvider: FileImage(file),
          );
        }
      )
    );
  }
}