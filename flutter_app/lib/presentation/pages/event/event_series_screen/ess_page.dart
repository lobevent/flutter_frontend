import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_series_invitation.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/loading_button.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/cubit/event_series_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/event_recent_upcoming_tabs.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/ess_inv_card.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/ess_invite_friends_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/generic_invite_friends/gen_invite_friends_button.dart';

import '../../../../domain/profile/profile.dart';
import '../event_form/widgets/invite_friends_widget.dart';

class EventSeriesScreenPage extends StatelessWidget {
  final UniqueId seriesId;

  const EventSeriesScreenPage({Key? key, required this.seriesId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventSeriesScreenCubit(seriesId: seriesId),
      child: BlocBuilder<EventSeriesScreenCubit, EventSeriesScreenState>(
          // this is here, so we dont get an error when we change subscribtion status
          buildWhen: (previous, current) =>
              !(current.status == EventSeriesScreenStatus.loading),
          builder: (context, state) {
            return BasicContentContainer(
                isLoading: state.status == EventSeriesScreenStatus.loading,
                child_ren: right(
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: state.status == EventSeriesScreenStatus.loaded
                          ? [
                              Text(
                                  "Event Series: " +
                                      state.eventSeries.name.getOrCrash(),
                                  style: AppTextStyles.stdLittleHeading),
                              PaddingRowWidget(
                                centered: true,
                                paddingTop: 25,
                                paddingBottom: 25,
                                children: [
                                  Text(
                                    "Subscribers: " +
                                        state.eventSeries.subscribersCount
                                            .toString(),
                                    style: AppTextStyles.stdText,
                                  ),
                                  //EssInviteFriendsWidget(),
                                  GenInviteFriendsButton<EventSeriesInvitation>(
                                    inviteFriendsButtonType:
                                        InviteFriendsButtonType.eventseries,
                                    eventSeriesId: seriesId.value.toString(),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Events: " +
                                        state.eventSeries.eventCount.toString(),
                                    style: AppTextStyles.stdText,
                                  ),
                                ],
                              ),
                              PaddingRowWidget(centered: true, children: [
                                Spacer(),
                                SubscriptionButton(context, state),
                                Spacer()
                              ]),
                              // this provides the tab bar and the contents of the tabs; namely it displays the events in ListTiles within a listview
                              Expanded(
                                child: EventTabs(
                                  upcoming:
                                      state.eventSeries.upcomingEvents ?? [],
                                  recendEvents:
                                      state.eventSeries.recentEvents ?? [],
                                  isLoading: false,
                                ),
                              )
                            ]
                          : [Text("")]),
                ));
          }),
    );
  }

  Widget SubscriptionButton(
      BuildContext context, EventSeriesScreenState state) {
    if (state.status == EventSeriesScreenStatus.loaded) {
      if (!(state.eventSeries.subscribed ?? false)) {
        return TextWithIconButton(
          onPressed: () {
            context.read<EventSeriesScreenCubit>().subscribe();
          },
          icon: AppIcons.subscribe,
          text: '',
        );
      } else {
        return TextWithIconButton(
          onPressed: () {
            context.read<EventSeriesScreenCubit>().unsubscribe();
          },
          icon: AppIcons.revokeSubscription,
          text: '',
        );
      }
    }
    return Text("");
  }
}
