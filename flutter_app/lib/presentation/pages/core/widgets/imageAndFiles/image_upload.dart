import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/infrastructure/core/file_remote_service.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// NOT READY YET DUE TO LACK OF KNOWLEDGE AND CONCEPT -> No comments yet
class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key, this.title = "bla"}) : super(key: key);

  final String? title ;

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  @override
  Widget build(BuildContext context) {
    return BasicContentContainer(
      scrollable: true,
      children: [ImageUploadPicker(returnFunction: (List<XFile?>? blaa){})],
    );

  }
}


class ImageUploadPicker extends StatefulWidget {
  const ImageUploadPicker({Key? key, this.title = "bla", required this.returnFunction, this.showMultiPic = false}) : super(key: key);

  final void Function(List<XFile?>?) returnFunction;
  final bool showMultiPic;
  final String? title ;

  @override
  _ImageUploadPickerState createState() => _ImageUploadPickerState();
}

class _ImageUploadPickerState extends State<ImageUploadPicker> {
  bool kIsWeb = false;

  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;


  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [Column(children: [
          if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) FutureBuilder<void>(
          future: retrieveLostData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text(
                  'You have not yet picked an image.',
                  textAlign: TextAlign.center,
                );
              case ConnectionState.done:
                return _handlePreview();
              default:
                if (snapshot.hasError) {
                  return Text(
                    'Pick image/video error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                }
            }
          },
        ) else _handlePreview(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              TextWithIconButton(onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              }, text: "", icon: Icons.photo,),
              Spacer(),
              if (widget.showMultiPic) TextWithIconButton(onPressed: () {
                    isVideo = false;
                    _onImageButtonPressed(
                    ImageSource.gallery,
                    context: context,
                    isMultiImage: true,
                    );
                  },
                 text: "", icon: Icons.photo_library,
              ),
              Spacer(),
              TextWithIconButton(onPressed: () {
                isVideo = false;
                _onImageButtonPressed(ImageSource.camera, context: context);
              }, text: "", icon: Icons.camera_alt,),

              Spacer(),
            ],
          ),
        ]
      )

    ]);

  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final List<XFile>? pickedFileList = await _picker.pickMultiImage(
          maxWidth: 1000,
          maxHeight: 900,
          imageQuality: 80,
        );
        setState(() {
          _imageFileList = pickedFileList;
        });
        widget.returnFunction(pickedFileList);
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {

      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1000,
          maxHeight: 900,
          imageQuality: 80,
        );
        setState(() {
          _imageFile = pickedFile;
        });
        widget.returnFunction([pickedFile]);
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }


  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }


  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 20.0,
            minWidth: 20.0,
            maxHeight: 90.0,
            maxWidth: 90.0,
          ),
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
              // Why network for web?
              // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
              return kIsWeb
                    ? Image.network(_imageFileList![index].path)
                    : Image.file(File(_imageFileList![index].path));
            },
            itemCount: _imageFileList!.length,
          ));
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      isVideo = false;
      setState(() {
        _imageFile = response.file;
        _imageFileList = response.files;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }


}


