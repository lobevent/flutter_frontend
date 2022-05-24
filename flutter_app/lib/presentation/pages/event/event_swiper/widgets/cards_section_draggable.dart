import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
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

  @override
  void initState() {
    super.initState();

    for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
      cards.add(
          EventCardDraggable(cardsCounter, widget.eventsList[cardsCounter]));
    }
  }

  @override
  Widget build(BuildContext context) {
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
      if(cards.length+cardsCounter>widget.eventsList.length-1){
        cards[0] = EventCardDraggable(cardsCounter, null);
        cards[1] = EventCardDraggable(cardsCounter, null);
        cards[2] = EventCardDraggable(cardsCounter, null);
      }else{
        // Swap cards
        var temp = EventCardDraggable(cardsCounter, widget.eventsList[cards.length+cardsCounter]);
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
        eventScreenContext
            .read<EventScreenCubit>()
            .changeStatus(EventStatus.attending);
        //widget.eventScreenContext.read<EventScreenCubit>().changeStatus(EventStatus.attending);

        changeCardsOrder();
        setState(() => dragOverTarget = false);
      }, onLeave: (_) {
        setState(() => dragOverTarget = false);
        eventScreenContext
            .read<EventScreenCubit>()
            .changeStatus(EventStatus.notAttending);
      }),
    );
  }
}
