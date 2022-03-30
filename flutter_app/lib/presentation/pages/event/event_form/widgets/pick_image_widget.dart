import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';
import 'package:image_picker/image_picker.dart';

class PickImageWidget extends StatefulWidget {
  const PickImageWidget({
    Key? key,
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
    if (preview != null) {
      return ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 20.0,
            minWidth: 20.0,
            maxHeight: 90.0,
            //maxWidth: 90.0,
          ),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.file(File(preview!.path)).image
                )),
            // child: dotenv.env['isWeb'] == "true"
            //     ? Image.network(preview!.path)
            //     : Image.file(File(preview!.path)),

          )
          );
    }
    return Text("blaa");
  }
}
