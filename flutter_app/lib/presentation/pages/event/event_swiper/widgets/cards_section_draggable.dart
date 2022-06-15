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
    for (cardsCounter = 0; cardsCounter < 3 && cardsCounter <= widget.eventsList.length - 1; cardsCounter++) {
        //add event cardsf
        Event event = widget.eventsList[cardsCounter];
        cards.add(EventCardDraggable(cardsCounter, widget.eventsList[cardsCounter]));
    }
    cardsCounter--;
    if (widget.eventsList.length == 0) {
      //add blank cards
      cards.add(EventCardDraggable(cardsCounter, null));
    }
  }

  @override
  void initState() {
    super.initState();
    addCards();
  }

  @override
  Widget build(BuildContext context) {
      return buildEventCards();
  }


  Widget buildEventCards() {
    return BlocProvider(
      create: (eventScreenContext) => EventScreenCubit(widget.eventsList[0].id),
      child: BlocBuilder<EventScreenCubit, EventScreenState>(
        builder: (eventScreenContext, state) {
          // ------------------------------------------------ GENERATE LIST OF WIDGETS -----------------------

          //this is the first list, so we can add the drag Targets!
          List<Widget> list = [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[dragTarget(eventScreenContext), Flexible(flex: 2, child: Container()), dragTarget(eventScreenContext)],
            )
          ];
          // here are the cards
          list.addAll(List.generate(
            cards.length,
            (index) {
              Widget card = SizedBox.fromSize(
                size: Size(MediaQuery.of(context).size.width * (0.9 - index * 0.1), MediaQuery.of(context).size.height * (0.6 - index * 0.05)),
                child: cards[index],
              );

              return Align(
                alignment: Alignment(
                    0.0,
                    index == 0
                        ? 0.0
                        : index == 2
                            ? 1.0
                            : 0.8),
                child: index == 0
                    ? Draggable(
                        data: [],
                        feedback: SizedBox.fromSize(
                          size: Size(
                              MediaQuery.of(context).size.width * (0.9 - index * 0.1), MediaQuery.of(context).size.height * (0.6 - index * 0.05)),
                          child: cards[0],
                        ),
                        child: card,
                        childWhenDragging: Container(),
                      )
                    : IgnorePointer(child: card),
              );
            },
          ));

          // ----------------------------------------------------------------------------------------------------------------------
          // -------------------------------------------Here is the actual return   -------------------------------------------
          // ----------------------------------------------------------------------------------------------------------------------
          return Expanded(
              child: Stack(
                  // -------------- HERE THE LIST FROM ABOVE IS USED -----------------------------
                  children: list.reversed.toList()));
        },
      ),
    );
  }

  void changeCardsOrder() {
    setState(() {
      //check if out of array bound
      if (cardsCounter + cards.length >= widget.eventsList.length) {
        cards.remove(cards[0]);
        if(cards.length == 0){
          cards.add(EventCardDraggable(cardsCounter, null));
        }
      } else {
        // Swap cards
        var temp = EventCardDraggable(cardsCounter, widget.eventsList[cards.length + cardsCounter]);
        //remove the first card and add the new to the end
        cards.remove(cards[0]);
        cards.add(temp);
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
