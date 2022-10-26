import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/loading_button.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/palk_animation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/timer_widget.dart';
import 'package:flutter_frontend/presentation/pages/feed/event_timer/cubit/event_timer_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import '../../../../domain/event/event.dart';

class FeedEventTimer extends StatefulWidget {
  const FeedEventTimer({Key? key}) : super(key: key);

  @override
  State<FeedEventTimer> createState() => _FeedEventTimerState();
}

class _FeedEventTimerState extends State<FeedEventTimer> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventTimerCubit(),
      child: BlocBuilder<EventTimerCubit, EventTimerState>(
        builder: (context, state) {
          return state.maybeMap(loading: (loadingState) {
            return SliverToBoxAdapter(child: const PalkAnimation(size: 50));
          }, loaded: (loadedState) {
            //check if events is in 7 days and the event is not null
            if (loadedState.event != null &&
                loadedState.event!.date
                    .isBefore(DateTime.now().add(const Duration(days: 7)))) {
              return SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  flexibleSpace: Padding(
                      padding: EdgeInsets.all(5),
                      child: FittedBox(
                          child: EventTimer(loadedState.event!, context))));
            } else {
              return SliverToBoxAdapter(child: SizedBox.shrink());
            }
          }, error: (err) {
            return SliverToBoxAdapter(child: ErrorWidget(err.error));
          }, orElse: () {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          });
        },
      ),
    );
  }

  Widget EventTimer(Event event, BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Text(event.name.getOrCrash()),
          TimerWidget(dateTime: event.date)
        ],
      ),
      onTap: () => context.router.push(EventScreenPageRoute(eventId: event.id)),
    );
  }
}
