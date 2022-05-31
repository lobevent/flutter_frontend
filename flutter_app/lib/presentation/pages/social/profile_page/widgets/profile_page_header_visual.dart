import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Profile/ProfileImagePickerWidget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/cubit/profile_page_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import '../../../../../data/storage_shared.dart';
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
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
        builder: (context, state) {
      return Row(children: [
        //Spacer is used to center the content
        const Spacer(),
        // circle Avatar is from flutter, its a Round image
        //inkwell for tap actions
        InkWell(
          onTap: () async {
            //context.router.push(ProfileImagePickerWidgetRoute());
            if (widget.profile != null && widget.profile!.ownProfile != null) {
              if (widget.profile!.images == null) {
                showImagePickerOverlay(context);
              } else {
                showImagePickerOverlay(context);
                /*await showDialog(
                    context: context,
                    builder: (_) => ImageDialog(
                            image: ProfileImage.getAssetsOrNetwork(
                          widget.profile!.images!,
                        )));

                 */
                //return ImageDialog(image: );
              }
            }
          },
          child: CircleAvatar(
            radius: 90,
            //child: widget.profile == null
            //  ? Text("")
            // : imageCarousell(widget.profile!.images!),
            //check if profile null, then display in loading state asset in loaded the profilepic or asset
            backgroundImage: widget.profile == null
                ? ProfileImage.returnProfileAsset()
                : ProfileImage.getAssetsOrNetwork(widget.profile!.images!),
            //child: imageCarousell(widget.profile!.images!)
          ),
        ),
        const Spacer(),
      ]);
    });
  }

  Widget imageCarousell(List<String> images) {
    return ImageCarousel(
      imagePaths: images,
      isLoadetFromWeb: true,
    );
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
