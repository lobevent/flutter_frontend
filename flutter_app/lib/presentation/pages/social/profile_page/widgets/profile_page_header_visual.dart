import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Profile/ProfileImagePickerWidget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/cubit/profile_page_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:get_it/get_it.dart';

import '../../../../../infrastructure/core/local/common_hive/common_hive.dart';
import '../../../../../domain/core/value_objects.dart';
import '../../../../../domain/profile/profile.dart';
import '../../../core/widgets/imageAndFiles/ImageCarousell.dart';

class ProfilePageHeaderVisual extends StatefulWidget {
  final String? imagePath;
  final Profile? profile;

  const ProfilePageHeaderVisual({Key? key, this.profile, this.imagePath})
      : super(key: key);

  @override
  State<ProfilePageHeaderVisual> createState() =>
      _ProfilePageHeaderVisualState();
}

class _ProfilePageHeaderVisualState extends State<ProfilePageHeaderVisual> {
  @override
  Widget build(BuildContext context) {
    bool isOwnProfile=true;
    if(widget.profile!=null){
      isOwnProfile =
      CommonHive.checkIfOwnId(widget.profile!.id.value.toString());
    }
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
        builder: (context, state) {
      return Row(children: [
        //Spacer is used to center the content
        const Spacer(),
        // circle Avatar is from flutter, its a Round image
        //inkwell for tap actions
        InkWell(
          onTap: () async {
            //check  if its own profile page for uploading
            if (widget.profile != null &&
                isOwnProfile) {
              //no pic is uploaded, so upload 1
              if (widget.profile!.images == null) {
                showImagePickerOverlay(context);
              } else {
                //show the picture as dialog
                ImageDialog.showInterActiveImageCarouselOverlay(
                    context, widget.profile!.images);
              }
            }
          },
          //our avatar
          child: CircleAvatar(
            radius: 90,
            //assetpic or uploaded pic?
            backgroundImage: decidePic(),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: isOwnProfile
                  ? InkWell(
                      onTap: () {
                        //upload profilepictures
                        showImagePickerOverlay(context);
                      },
                      child: Container(
                        color: Colors.grey.withOpacity(0.3),
                        child: Text("Upload"),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ),
        const Spacer(),
      ]);
    });
  }

  //show profilepic or assetimage
  ImageProvider decidePic() {
    if (widget.profile == null) {
      if (widget.imagePath != null) {
        return ProfileImage.getAssetOrNetwork(widget.imagePath);
      } else {
        return ProfileImage.returnProfileAsset();
      }
    } else {
      return ProfileImage.getAssetsOrNetwork(widget.profile!.images!);
    }
  }

  //overlay for image upload
  void showImagePickerOverlay(BuildContext buildContext) async {
    //initialise overlaystate and entries
    final OverlayState overlayState = Overlay.of(buildContext)!;
    //have to do it nullable
    OverlayEntry? overlayEntry;

    //this is the way to work with overlays
    overlayEntry = OverlayEntry(builder: (buildContext) {
      return ProfileImagePickerWidget(
          overlayEntry: overlayEntry!, cubitContext: context);
      //return TodoListForm(overlayEntry: overlayEntry!, cubitContext: context, event: eventPass,);
    });
    //insert the entry in the state to make it accesible
    overlayState.insert(overlayEntry);
  }
}
