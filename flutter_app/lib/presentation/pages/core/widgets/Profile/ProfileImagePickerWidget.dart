import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/ImageCarousell.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/cubit/profile_page_cubit.dart';
import 'package:image_picker/image_picker.dart';

// good tutorial: https://blog.logrocket.com/creating-image-carousel-flutter/
// TODO: open an Dialog with the image when clicking on it!
/// The image picker widged for posts!
class ProfileImagePickerWidget extends StatefulWidget {
  const ProfileImagePickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileImagePickerWidgetState createState() => _ProfileImagePickerWidgetState();
}

class _ProfileImagePickerWidgetState extends State<ProfileImagePickerWidget> {
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
    //return BlocProvider(
     //   create: (context) => ProfilePageCubit(profileId: profileId),
   // child:  BlocBuilder<ProfilePageCubit, ProfilePageState>(
     //   builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                Spacer(),
                Spacer(),
                previewImage(),
                ImageUploadPicker(returnFunction: (List<XFile?>? image) {
                  if (image != null && image.length > 0) {
                    preview = image;
                    context.read<ProfilePageCubit>().changePictures(preview);
                    setState(() {});
                  }
                }, showMultiPic: true,),
                TextWithIconButton(
                    onPressed: (){
                      context.read<ProfilePageCubit>().postProfilePics();
                      setState(() {});
                    },
                    text: "Upload profile pictures"),
                Spacer(),
              ],
            ),
          );
       // }
 //   ),
   // );
  }


  /// This is the image Preview with an Carousel, because we do support multilist here
  Widget previewImage() {
    if (preview != null) {
      // this check is for the eventuality that somone does not select an image when going into galery!
      if(preview.contains(null)){
        preview = [];
      }
      List<String> pathlist = preview.length != 0 ? preview.map((e) => e!.path).toList() : [];
      return ImageCarousel(imagePaths: pathlist, isLoadetFromWeb: false,);

    }
    return Spacer();
  }



}
