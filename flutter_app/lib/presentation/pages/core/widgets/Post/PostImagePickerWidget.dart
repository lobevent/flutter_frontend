import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/cubit/post_screen_cubit.dart';
import 'package:image_picker/image_picker.dart';

// good tutorial: https://blog.logrocket.com/creating-image-carousel-flutter/
// TODO: open an Dialog with the image when clicking on it!
/// The image picker widged for posts!
class PostImagePickerWidget extends StatefulWidget {
  const PostImagePickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  _PostImagePickerWidgetState createState() => _PostImagePickerWidgetState();
}

class _PostImagePickerWidgetState extends State<PostImagePickerWidget> {
  List<XFile?> preview = [];
  late PageController _pageController;
  int activePage = 0;
  //int maxImages = 5;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostScreenCubit, PostScreenState>(
        builder: (context, state) {
          return Column(
            children: [
              previewImage(),
              ImageUploadPicker(returnFunction: (List<XFile?>? image) {
                if (image != null && image.length > 0) {
                  preview = image;
                  context.read<PostScreenCubit>().changePictures(preview);
                  setState(() {});
                }
              }, showMultiPic: true,),
            ],
          );
        }
    );
  }


  /// This is the image Preview with an Carousel, because we do support multilist here
  Widget previewImage() {
    if (preview != null) {
      return  Column(
        children: [ConstrainedBox(
          constraints: new BoxConstraints(
            minWidth: 20.0,
            maxHeight: preview.length == 0 ? 10 : 120.0,
          ),
          child:

                  PageView.builder(
                      // mainly for the indicators, so they are updated
                      onPageChanged: (page) {
                        setState(() {
                          activePage = page;
                        });
                      },
                      controller: _pageController,
                      itemCount: preview.length,
                      pageSnapping: true,
                      itemBuilder: (context,pagePosition){
                        // we use container, because we use the images as boxdecoration
                        return Container(
                          // so the images dont overlap
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.file(File(preview[pagePosition]!.path)).image
                              )),

                        );}),


              ),
          // The indicators!
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(preview.length, activePage))
        ]
              // Pageview so we have a nice little carousel

      );
    }
    return Spacer();
  }



  /// This method generate indicator dots in the image preview
  List<Widget> indicators(int imagesLength, int currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }
}
