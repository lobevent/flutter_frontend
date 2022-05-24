import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'event_card_alignment.dart';
import 'dart:math';

List<Alignment> cardsAlign = [
  Alignment(0.0, 1.0),
  Alignment(0.0, 0.8),
  Alignment(0.0, 0.0)
];
List<Size> cardsSize = [];

class CardsSectionAlignment extends StatefulWidget {
  final List<Event> eventsList;
  final BuildContext cubitContext;
  CardsSectionAlignment(this.eventsList, this.cubitContext) {
    final eventsList = this.eventsList;
    final cubitContext = this.cubitContext;
    cardsSize.add(Size(MediaQuery.of(cubitContext).size.width * 0.95,
        MediaQuery.of(cubitContext).size.height * 0.6));
    cardsSize.add(Size(MediaQuery.of(cubitContext).size.width * 0.9,
        MediaQuery.of(cubitContext).size.height * 0.55));
    cardsSize.add(Size(MediaQuery.of(cubitContext).size.width * 0.85,
        MediaQuery.of(cubitContext).size.height * 0.5));
  }

  @override
  _CardsSectionState createState() => _CardsSectionState(cubitContext);
}

class _CardsSectionState extends State<CardsSectionAlignment>
    with SingleTickerProviderStateMixin {
  _CardsSectionState(this.cubitContext);

  final BuildContext cubitContext;
  int cardsCounter = 0;

  List<EventCardAlignment> cards = [];
  late AnimationController _controller;

  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);
  late Alignment frontCardAlign;
  double frontCardRot = 0.0;

  @override
  void initState() {
    super.initState();

    // Init cards
    for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
      cards.add(
          EventCardAlignment(cardsCounter, widget.eventsList[cardsCounter]));
    }

    frontCardAlign = cardsAlign[2];

    // Init the animation controller
    _controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      children: <Widget>[
        backCard(),
        middleCard(),
        frontCard(),

        // Prevent swiping if the cards are animating
        if (_controller.status != AnimationStatus.forward)
          SizedBox.expand(
              child: GestureDetector(
            // While dragging the first card
            onPanUpdate: (DragUpdateDetails details) {
              // Add what the user swiped in the last frame to the alignment of the card
              setState(() {
                // 20 is the "speed" at which moves the card
                frontCardAlign = Alignment(
                    frontCardAlign.x +
                        20 *
                            details.delta.dx /
                            MediaQuery.of(context).size.width,
                    frontCardAlign.y +
                        40 *
                            details.delta.dy /
                            MediaQuery.of(context).size.height);

                frontCardRot = frontCardAlign.x; // * rotation speed;
              });
            },
            // When releasing the first card
            onPanEnd: (_) {
              // If the front card was swiped far enough to count as swiped
              if (frontCardAlign.x > 3.0 || frontCardAlign.x < -3.0) {
                animateCards();
              } else {
                // Return to the initial rotation and alignment
                setState(() {
                  frontCardAlign = defaultFrontCardAlign;
                  frontCardRot = 0.0;
                });
              }
            },
          ))
        else
          Container(),
      ],
    ));
  }

  Widget backCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: cards[2]),
    );
  }

  Widget middleCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: cards[1]),
    );
  }

  Widget frontCard() {
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(size: cardsSize[0], child: cards[0]),
        ));
  }

  void addNewCards(int counter) {
    cards.add(EventCardAlignment(counter, widget.eventsList[counter]));
    cards.add(EventCardAlignment(counter + 1, widget.eventsList[counter + 1]));
  }

  void changeCardsOrder() {
    setState(() {
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a  bottom card)
      var temp = EventCardAlignment(cardsCounter, widget.eventsList[cards.length+cardsCounter]);
      //change cards order ...
      cards[0] = cards[1];
      cards[1] = cards[2];
      cards[2] = temp;

      cardsCounter++;

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size?> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size?> middleCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return AlignmentTween(
            begin: beginAlign,
            end: Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(CurvedAnimation(
            parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
