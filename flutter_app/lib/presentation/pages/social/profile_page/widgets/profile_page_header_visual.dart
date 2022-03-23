import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';

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
      CircleAvatar(
        radius: 90,
        backgroundImage: ProfileImage.getAssetOrNetwork(imagePath),
      ),
      const Spacer(),
    ]);
  }
}
