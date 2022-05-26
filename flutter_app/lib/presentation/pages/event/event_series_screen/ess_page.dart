import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/cubit/event_series_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/eventseries_list/widgets/esl_page_eventTabs.dart';

class EventSeriesScreenPage extends StatelessWidget {
  final UniqueId seriesId;
  const EventSeriesScreenPage({Key? key, required this.seriesId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventSeriesScreenCubit(seriesId: seriesId),
      child: BlocBuilder<EventSeriesScreenCubit, EventSeriesScreenState>(builder: (context, state) {
        return BasicContentContainer(
            isLoading: state is ESS_Loading,
            child_ren: right(Column(
              mainAxisSize: MainAxisSize.min,
              children: state.maybeMap(
                  orElse: () {
                    return [];
                  },
                  ready: (state) => [
                        Text("Event Series: " + state.series.name.getOrCrash(), style: AppTextStyles.stdLittleHeading),
                        PaddingRowWidget(
                          centered: true,
                          paddingTop: 25,
                          paddingBottom: 25,
                          children: [
                            Text(
                              "Subscribers: " + state.series.subscribersCount.toString(),
                              style: AppTextStyles.stdText,
                            ),
                            Spacer(),
                            Text(
                              "Events: " + state.series.eventCount.toString(),
                              style: AppTextStyles.stdText,
                            ),
                          ],

                        ),
                        PaddingRowWidget(
                          centered: true,
                          children: [
                            Spacer(),
                            TextWithIconButton(onPressed: (){context.read<EventSeriesScreenCubit>().subscribe();}, icon: AppIcons.subscribe, text: '',),
                            Spacer()
                          ]),
                        // this provides the tab bar and the contents of the tabs; namely it displays the events in ListTiles within a listview
                        EventTabs(upcoming: state.series.upcomingEvents ?? [], recendEvents: state.series.recentEvents ?? [])
                      ]),
            )));
      }),
    );
  }
  
  
}
