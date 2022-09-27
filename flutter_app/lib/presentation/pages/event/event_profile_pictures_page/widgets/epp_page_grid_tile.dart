import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/domain/event/event_profile_picture.dart';

class EppGridListTile extends StatelessWidget {

  final EventProfilePicture epp;


  const EppGridListTile({Key? key, required this.epp}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ImageProvider image = Image.network(dotenv.env['ipSim']!.toString() + epp.path).image;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 10, minWidth: 10, maxHeight: 30, minHeight: 30),
      child: GestureDetector(
        child: Container(
          child: GestureDetector(),
          decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.cover, image: image)),
        ),
      ),
    );
  }
}
