import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/data/common_hive.dart';
import 'package:flutter_frontend/domain/event/event_profile_picture.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';

class EppGridListTile extends StatelessWidget {

  final EventProfilePicture epp;


  const EppGridListTile({Key? key, required this.epp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool own = CommonHive.checkIfOwnId(epp.profile.id.value.toString());

    ImageProvider image = Image.network(dotenv.env['ipSim']!.toString() + epp.path).image;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 10, minWidth: 10, maxHeight: 30, minHeight: 30),
      child: GestureDetector(
        child: Container(
          child: GestureDetector(),
          decoration: BoxDecoration(
            border: own ? Border.all(color: AppColors.accentColor, width: 2) : null,
              image: DecorationImage(fit: BoxFit.cover, image: image)),
        ),
      ),
    );
  }
}
