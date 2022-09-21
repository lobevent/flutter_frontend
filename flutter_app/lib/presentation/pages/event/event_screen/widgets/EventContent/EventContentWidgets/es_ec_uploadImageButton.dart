import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';

class UploadImageButton extends StatefulWidget {
  const UploadImageButton({Key? key}) : super(key: key);

  @override
  State<UploadImageButton> createState() => _UploadImageButtonState();
}

class _UploadImageButtonState extends State<UploadImageButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () => _onClick(), icon: Icon(AppIcons.uploadImage));
  }


  _onClick(){
    showDialog(context: context, builder: (BuildContext context){
       return AlertDialog(
           content:       ImageUploadPicker(returnFunction: (files){}, hideGalery: true, showPreview: true,));
    });
  }

}
