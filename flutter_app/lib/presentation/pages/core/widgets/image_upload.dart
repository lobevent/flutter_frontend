import 'package:flutter/material.dart';
import 'package:flutter_frontend/infrastructure/core/file_remote_service.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
 
class ImageUpload extends StatefulWidget {
  ImageUpload({required Key key}) : super(key: key);

  @override
  ImageUploadState createState() => ImageUploadState();
}
 
class ImageUploadState extends State<ImageUpload> {
 
  final ImagePicker _picker = ImagePicker();
  late XFile imageFile;

  Future<void> _pickImage() async{
    try{
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
       setState(() async {
        imageFile = image!;
        await UploadFile().uploadFile(imageFile.path);
      });
    } catch (e) {
      print("Image picker error");
    }
  }
  //Handling MainActivity destruction on Android 
  //   Future<void> retriveLostData() async {
  //   final LostData response = await _picker.getLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     setState(() {
  //       imageFile = response.file;
  //     });
  //   } else {
  //     print('Retrieve error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker'),
      ),
      body: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image from gallery',
        child: Icon(Icons.photo_library),
      ), 
    );
  }
}
