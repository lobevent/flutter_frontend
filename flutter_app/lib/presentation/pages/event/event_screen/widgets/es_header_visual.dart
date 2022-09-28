import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/widgets/imageAndFiles/ImageCarousell.dart';
import '../../../core/widgets/imageAndFiles/image_classes.dart';

class HeaderVisual extends StatelessWidget {
  final String? networkImagePath;

  const HeaderVisual({this.networkImagePath});

  @override
  Widget build(BuildContext context) {
    //Object image = networkImagePath == null ? AssetImage("assets/images/partypeople.jpg") : NetworkImage(dotenv.env['ipSim']!.toString() + '/uploads/private' + networkImagePath!);
    ImageProvider image;

    if (networkImagePath == null) {
      image = AssetImage("assets/images/partypeople.jpg");
    } else {
      try {
        image =
            NetworkImage(dotenv.env['ipSim']!.toString() + networkImagePath!);
      } catch (e) {
        print(e);
        return Container();
      }
    }
    return InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: image,
            ),
          ),
        ),
        onTap: () async {
          ImageDialog.showInterActiveImageOverlay(context, networkImagePath);
        });
    //return imagecaroussel and u can click on the seperate images again

    /*InkWell(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: image,
                ),
              ),
            ),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (_) {
                  return FittedBox(
                    fit: BoxFit.contain,
                    child: ImageDialog(
                      image:
                          ProfileImage.getAssetsOrNetwork([networkImagePath]),
                    ),
                  );
                },
              );
            },
          ),*/
  }
}
