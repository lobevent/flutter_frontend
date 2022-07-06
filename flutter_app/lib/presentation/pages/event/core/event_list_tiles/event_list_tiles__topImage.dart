import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import '../../../../../domain/event/event.dart';


class TopImage extends StatelessWidget {
  final Event event;

  const TopImage({required this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showEvent(context),
      child: ImageWidget(context, event.image),
    );
  }



  ///
  /// Checks if imagePath exists and shows other stdimage if not
  ///
  Widget ImageWidget(BuildContext context, String? imagePath){
    ImageProvider image;
    if(imagePath == null){
      image = AssetImage("assets/images/partypeople.jpg");
    }
    else {
      image = NetworkImage(dotenv.env['ipSim']!.toString() +  imagePath);
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image,
        ),
      ),
    );
  }

  void showEvent(BuildContext context) {
    context.router.push(EventScreenPageRoute(eventId: event.id));
  }
}
