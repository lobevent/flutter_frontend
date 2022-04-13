import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';
import 'package:image_picker/image_picker.dart';

class PickImageWidget extends StatefulWidget {
  final String? loadetFile;
  const PickImageWidget({
    Key? key, this.loadetFile,
  }) : super(key: key);

  @override
  _PickImageWidgetState createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  XFile? preview;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormCubit, EventFormState>(
        builder: (context, state) {
          return Column(
            children: [
              previewImage(),
              ImageUploadPicker(returnFunction: (List<XFile?>? image) {
            if (image != null && image.length > 0) {
              preview = image[0];
              context.read<EventFormCubit>().changePicture(preview!);
              setState(() {});
            }
          }),
            ],
          );
        }
    );
  }


  Widget previewImage() {
    ImageProvider? image;
    if(widget.loadetFile != null){
      image = NetworkImage(dotenv.env['ipSim'].toString() + widget.loadetFile!);
    }
    if(preview != null){
      image = Image.file(File(preview!.path)).image;
    }
    if (image != null) {
      return ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 20.0,
            minWidth: 20.0,
            maxHeight: 90.0,
          ),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: image
                )),

          )
          );
    }
    return Text("blaa");
  }
}
