import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/data/icons_with_texts.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/chip_choice.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';

class EventList_Bar extends StatefulWidget {
  const EventList_Bar({Key? key}) : super(key: key);

  @override
  State<EventList_Bar> createState() => _EventList_BarState();
}

class _EventList_BarState extends State<EventList_Bar> {
  final GlobalKey<ChipChoiceState> myKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 10.0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      automaticallyImplyLeading: false,
      pinned: true,
      //lat 37.4219983 long -122.084
      bottom: myKey.currentState?.value! == 0
          ? PreferredSize(
        preferredSize: const Size(90, 70),
        child: Slider.adaptive(
            value: context.read<EventsMultilistCubit>().kilometersVal,
            min: 0,
            max: 50,
            divisions: 50,
            label: context
                .read<EventsMultilistCubit>()
                .kilometersVal
                .toString(),
            onChangeEnd: (newRating) {
              context
                  .read<EventsMultilistCubit>()
                  .getEvents(EventScreenOptions.near, newRating.ceil());
            },
            onChanged: (newRating) {
              setState(() {
                context.read<EventsMultilistCubit>().kilometersVal =
                    newRating;
              });
            }),
      )
          : const PreferredSize(preferredSize: Size(0, 40), child: Text("")),
      flexibleSpace: Column(
          children: [
            Row(
              children: [
                ChipChoice(
                  key: myKey,
                  list: {
                    // "own": (bool bla) {
                    //   context
                    //       .read<EventsMultilistCubit>()
                    //       .getEvents(EventScreenOptions.owned);
                    // },
                    "near": (bool bla) {
                      context.read<EventsMultilistCubit>().getEvents(
                          EventScreenOptions.near,
                          context.read<EventsMultilistCubit>().kilometersVal.ceil());
                    },
                    // "recent": (bool bla) {
                    //   context
                    //       .read<EventsMultilistCubit>()
                    //       .getEvents(EventScreenOptions.recent);
                    // },
                    "invited": (bool bla) {
                      context
                          .read<EventsMultilistCubit>()
                          .getEvents(EventScreenOptions.invited);
                    },
                    "attending": (bool bla) {
                      context
                          .read<EventsMultilistCubit>()
                          .getEvents(EventScreenOptions.ownAttending);
                    },
                  },
                ),
              ],
            ),
            Row(
              children: [
                Spacer(),
                ChoiceChip(
                  label: TextWithIcon(icon: Icons.history, text: "recent",),
                  selected: context.read<EventsMultilistCubit>().LoadPastEvents,
                  onSelected: (bool selted){
                    setState(() {
                      context.read<EventsMultilistCubit>().LoadPastEvents = !context.read<EventsMultilistCubit>().LoadPastEvents;
                    });
                    },),
                Spacer()
              ],
            ),
          ],
        ),
    );
  }
}
