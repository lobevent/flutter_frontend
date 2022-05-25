import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_swiper/cubit/event_swiper_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_swiper/widgets/cards_section_alignment.dart';
import 'package:flutter_frontend/presentation/pages/event/event_swiper/widgets/cards_section_draggable.dart';

import '../../../../domain/event/event.dart';

class EventSwiper extends StatefulWidget {
  @override
  _EventSwiperState createState() => _EventSwiperState();
}

class _EventSwiperState extends State<EventSwiper> {
  bool showAlignmentCards = false;
  List<Event> eventList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (swiperContext) => EventSwiperCubit(),
      child: BlocBuilder<EventSwiperCubit, EventSwiperState>(
        builder: (swiperContext, state) {
          return Scaffold(
            /*appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {}, icon: Icon(Icons.settings, color: Colors.grey)),
            title: Switch(
              onChanged: (bool value) => setState(() => showAlignmentCards = value),
              value: showAlignmentCards,
              activeColor: Colors.red,
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.question_answer, color: Colors.grey)),
            ],
          ),

           */
            bottomNavigationBar:
                BottomNavigation(selected: NavigationOptions.eventSwiper),
            backgroundColor: Colors.white,
            body: Column(
                children: state.maybeMap((value) => [Text("tessst")],
                    loading: (loadingState) => [Text("Loading")],
                    loaded: (loadedState) => [
                          CardsSectionDraggable(
                              loadedState.eventsList, swiperContext)
                        ],
                    orElse: () => [Text("Something happened")])
                //<Widget>[
                //(showAlignmentCards)
                //?
                //CardsSectionAlignment(context)
                // : CardsSectionDraggable(),
                //buttonsRow()
                //],
                ),
          );
        },
      ),
    );
  }

  /*
  Widget buttonsRow() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            mini: true,
            heroTag: null,
            onPressed: () {},
            backgroundColor: Colors.white,
            child: Icon(Icons.loop, color: Colors.yellow),
          ),
          Padding(padding: EdgeInsets.only(right: 8.0)),
          FloatingActionButton(
            onPressed: () {},
            heroTag: null,
            backgroundColor: Colors.white,
            child: Icon(Icons.close, color: Colors.red),
          ),
          Padding(padding: EdgeInsets.only(right: 8.0)),
          FloatingActionButton(
            onPressed: () {},
            heroTag: null,
            backgroundColor: Colors.white,
            child: Icon(Icons.favorite, color: Colors.green),
          ),
          Padding(padding: EdgeInsets.only(right: 8.0)),
          FloatingActionButton(
            mini: true,
            heroTag: null,
            onPressed: () {},
            backgroundColor: Colors.white,
            child: Icon(Icons.star, color: Colors.blue),
          ),
        ],
      ),
    );
  }

   */
}
