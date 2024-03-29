import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/animated_check.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/loading_button.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageButton extends StatefulWidget {

  const UploadImageButton({Key? key}) : super(key: key);

  @override
  State<UploadImageButton> createState() => _UploadImageButtonState();
}

class _UploadImageButtonState extends State<UploadImageButton> {



  @override
  Widget build(BuildContext context) {

    return IconButton(onPressed: () => _onClick(context), icon: Icon(AppIcons.uploadImage));
  }


  /// The onClick Function opens an Dialog with the Image picker
  /// it should close after successfully submitting a picture
  _onClick(BuildContext cubitContext){
    //SystemSound.play(SystemSoundType.click);
    showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Dialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                  child: Container(
                      child: _ImagePickerEventScreen(
                        onPressedUpload: cubitContext.read<EventScreenCubit>().uploadImage,)
                  )
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: cubitContext,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Dialog();
    });
  }

}

/// An implementation of the imagepicker it uses ImageUploadPickerWidget
/// it takes an async function which is called on pressed
/// it is an Statefull widget as the content will change (picture preview, Loading animation)
class _ImagePickerEventScreen extends StatefulWidget {
  final Future<bool> Function(XFile) onPressedUpload;
  const _ImagePickerEventScreen({Key? key, required this.onPressedUpload}) : super(key: key);

  @override
  State<_ImagePickerEventScreen> createState() => _ImagePickerEventScreenState();
}

class _ImagePickerEventScreenState extends State<_ImagePickerEventScreen> with SingleTickerProviderStateMixin{

  XFile? preview;
  bool loading = false;
  bool uploadSuccessfull = false;
  bool errorHappened = false;

  @override
  Widget build(BuildContext context) {
    if(!uploadSuccessfull) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // the image preview function
          previewImage(),
          // The image picker; it takes an function which is called when an image is returned
          ImageUploadPicker(
            returnFunction: (List<XFile?>? image) {
              if (image != null && image.length > 0) {
                preview = image[0];
                print(preview!.path);
                setState(() {});
              }
            },
            hideGalery: true,
            showPreview: false,
          ),

          if(errorHappened)
            Text(AppStrings.errorHappend, style: AppTextStyles.error,),

          // only show this button if an image is selected and the image isnt uploadet at the moment!
          if (preview != null && !loading)
            TextWithIconButton(
              text: "Upload Publicly",
              icon: AppIcons.uploadToEvent,
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                widget.onPressedUpload(preview!).then((value) async {
                  if(value){
                    // opens the successfull notification
                    setState(() {
                      uploadSuccessfull = true;
                    });
                    Future.delayed(Duration(milliseconds: 1000)).then((value) => Navigator.pop(context));
                  }
                  else{
                    setState(() {
                      loading = false;
                      errorHappened = true;
                    });
                  }



                });
              },
            ),
          // show the loading button if the image is being uploaded
          if (loading)
            LoadingButton(
              size: 35,
            )
        ],
      );
    }
    else{
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: EdgeInsets.only(top: 20, bottom: 20), child: AnimatedCheck(),)
        ],
      );
    }
  }




  // the preview Image function returns a widget with the image preview
  Widget previewImage() {
    ImageProvider? image;
    if(preview != null){
      image = Image.file(File(preview!.path)).image;
    }
    if (image != null) {
      return ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 20.0,
            minWidth: 20.0,
            maxHeight: 150.0,
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
    return Text("Nothing here yet");
  }
}

