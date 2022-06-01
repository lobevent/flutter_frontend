import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import '../../event_screen/cubit/event_screen/event_screen_cubit.dart';
import '../cubit/event_swiper_cubit.dart';
import 'event_card_draggable.dart';

class CardsSectionDraggable extends StatefulWidget {
  final List<Event> eventsList;
  final BuildContext cubitContext;

  CardsSectionDraggable(this.eventsList, this.cubitContext);

  @override
  _CardsSectionState createState() => _CardsSectionState(cubitContext);
}

class _CardsSectionState extends State<CardsSectionDraggable> {
  _CardsSectionState(this.cubitContext);
  bool dragOverTarget = false;
  final BuildContext cubitContext;

  List<EventCardDraggable> cards = [];
  int cardsCounter = 0;

  void addCards() {
    //add 3 cards for displaying blank cards
    for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
      if (widget.eventsList.length <= cardsCounter) {
        //add blank cards
        cards.add(EventCardDraggable(cardsCounter, null));
      } else {
        //add event cardsf
        cards.add(
            EventCardDraggable(cardsCounter, widget.eventsList[cardsCounter]));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addCards();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.eventsList.isEmpty || widget.eventsList[0] == null) {
      return buildNoEvents();
    } else {
      return buildEventCards();
    }
  }

  Widget buildNoEvents() {
    return Center(
      child: Text("No events available"),
    );
  }

  Widget buildEventCards() {
    return BlocProvider(
      create: (eventScreenContext) => EventScreenCubit(widget.eventsList[0].id),
      child: BlocBuilder<EventScreenCubit, EventScreenState>(
        builder: (eventScreenContext, state) {
          return Expanded(
              child: Stack(
            children: <Widget>[
              // Drag target row
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  dragTarget(eventScreenContext),
                  Flexible(flex: 2, child: Container()),
                  dragTarget(eventScreenContext)
                ],
              ),
              // Back card
              Align(
                alignment: Alignment(0.0, 1.0),
                child: IgnorePointer(
                    child: SizedBox.fromSize(
                  size: Size(MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.5),
                  child: cards[2],
                )),
              ),
              // Middle card
              Align(
                alignment: Alignment(0.0, 0.8),
                child: IgnorePointer(
                    child: SizedBox.fromSize(
                  size: Size(MediaQuery.of(context).size.width * 0.85,
                      MediaQuery.of(context).size.height * 0.55),
                  child: cards[1],
                )),
              ),
              // Front card
              Align(
                alignment: Alignment(0.0, 0.0),
                child: Draggable(
                  data: [1, 2, 3],
                  feedback: SizedBox.fromSize(
                    size: Size(MediaQuery.of(context).size.width * 0.9,
                        MediaQuery.of(context).size.height * 0.6),
                    child: cards[0],
                  ),
                  child: SizedBox.fromSize(
                    size: Size(MediaQuery.of(context).size.width * 0.9,
                        MediaQuery.of(context).size.height * 0.6),
                    child: cards[0],
                  ),
                  childWhenDragging: Container(),
                ),
              ),
            ],
          ));
        },
      ),
    );
  }

  void changeCardsOrder() {
    setState(() {
      //check if out of array bound
      if (cardsCounter + cards.length >= widget.eventsList.length) {
        cards[0] = EventCardDraggable(cardsCounter, null);
        cards[1] = EventCardDraggable(cardsCounter, null);
        cards[2] = EventCardDraggable(cardsCounter, null);
      } else {
        // Swap cards
        var temp = EventCardDraggable(
            cardsCounter, widget.eventsList[cards.length + cardsCounter]);
        //change cards order ...
        cards[0] = cards[1];
        cards[1] = cards[2];
        cards[2] = temp;

        cardsCounter++;
      }
    });
  }

  Widget dragTarget(BuildContext eventScreenContext) {
    return Flexible(
      flex: 1,
      child: DragTarget(builder: (_, __, ___) {
        return Container();
      }, onWillAccept: (_) {
        setState(() => dragOverTarget = true);
        return true;
      }, onAccept: (_) {
        //for attending the event
        //if (cardsCounter + cards.length > widget.eventsList.length) {
        /*eventScreenContext
            .read<EventScreenCubit>()
            .changeStatus(EventStatus.attending);

         */
        //}

        changeCardsOrder();
        setState(() => dragOverTarget = false);
      }, onLeave: (_) {
        setState(() => dragOverTarget = false);

        /*eventScreenContext
            .read<EventScreenCubit>()
            .changeStatus(EventStatus.notAttending);

         */

        //}
      }),
    );
  }
}
