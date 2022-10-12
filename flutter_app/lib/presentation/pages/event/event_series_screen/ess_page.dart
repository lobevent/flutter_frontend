import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/loading_button.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/cubit/event_series_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/event_recent_upcoming_tabs.dart';

class EventSeriesScreenPage extends StatelessWidget {
  final UniqueId seriesId;
  const EventSeriesScreenPage({Key? key, required this.seriesId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventSeriesScreenCubit(seriesId: seriesId),
      child: BlocBuilder<EventSeriesScreenCubit, EventSeriesScreenState>(
        // this is here, so we dont get an error when we change subscribtion status
        buildWhen: (previous, current) => !(current is ESS_ReadySubscrLoading),
          builder: (context, state) {
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
                            SubscriptionButton(),
                            Spacer()
                          ]),
                        // this provides the tab bar and the contents of the tabs; namely it displays the events in ListTiles within a listview
                        EventTabs(upcoming: state.series.upcomingEvents ?? [], recendEvents: state.series.recentEvents ?? [], isLoading: false,)
                      ]),
            )));
      }),
    );

  }


  Widget SubscriptionButton(){
    return BlocBuilder<EventSeriesScreenCubit, EventSeriesScreenState>(
        builder: (context, state) {
          return state.maybeMap(orElse: () => Spacer(),
              ready: (readyState){
                if(!(readyState.series.subscribed?? false)){
                  return TextWithIconButton(onPressed: (){context.read<EventSeriesScreenCubit>().subscribe();}, icon: AppIcons.subscribe, text: '',);
                }
                else{
                  return TextWithIconButton(onPressed: (){context.read<EventSeriesScreenCubit>().unsubscribe();}, icon: AppIcons.revokeSubscription, text: '',);
                }
              },
              readyAndLoadingSubscription: (l) => LoadingButton()
          );
        });

  }
}
