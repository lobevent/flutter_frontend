import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Profile/ProfileImagePickerWidget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/cubit/profile_page_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import '../../../../../data/storage_shared.dart';
import '../../../../../domain/core/value_objects.dart';


class ProfilePageHeaderVisual extends StatelessWidget {
  final String? imagePath;
  const ProfilePageHeaderVisual({Key? key, String? this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
          //Spacer is used to center the content
          const Spacer(),
          // circle Avatar is from flutter, its a Round image
          InkWell(
            onTap: (){
              context.router.push(ProfileImagePickerWidgetRoute());
              print("clicked");
            },
            child: CircleAvatar(
              radius: 90,
              backgroundImage: ProfileImage.getAssetOrNetwork(imagePath),
            ),
          ),
          const Spacer(),
        ]);
  }
}
