import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventCardDraggable extends StatelessWidget {
  final int cardNum;
  final Event? event;
  const EventCardDraggable(this.cardNum, this.event);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          context.router.push(EventScreenPageRoute(eventId: event!.id));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //load our image
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: Image(
                        image: ProfileImage.getAssetOrNetwork(event!.image)))),
            Container(
                color: Colors.white12,
                padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //displaz=y event title
                    Text(
                        event!.name.value.fold(
                                (l) => "Event Error", (r) => r.toString()) +
                            '$cardNum',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w700)),
                    Padding(padding: EdgeInsets.only(bottom: 8.0)),
                    //display eventdesc
                    OverflowSafeString(
                      child: Text(
                          event!.description!.value
                              .fold((l) => "Failure", (r) => r.toString()),
                          textAlign: TextAlign.start),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
