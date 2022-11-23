import 'package:dartz/dartz.dart' show left, Either;
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/eventseries_list/cubit/event_series_list_cubit.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/pages/event/eventseries_list/widgets/esl_list.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventSeriesListPage extends StatelessWidget {
  const EventSeriesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventSeriesListCubit(),
      child: BlocBuilder<EventSeriesListCubit, EventSeriesListState>(
          builder: (context, EventSeriesListState state) {
        return BasicContentContainer(
          scrollable: false,
          isLoading: state is ESL_Loading,
          bottomNavigationBar:
              BottomNavigation(selected: NavigationOptions.home),
          child_ren: left([
            Text(AppStrings.ownEventSeriesOverviewTitle,
                style: Theme.of(context).textTheme.headline3),
            EventSeriesTabs()
          ]),
        );
      }),
    );
  }

  Widget EventSeriesTabs() {
    return DefaultTabController(
        length: 2,
        child: Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          const TabBar(
            indicatorColor: AppColors.stdIndicatedTabColor,
            tabs: [
              StdSpacedIconTextTab(text: "Own", iconHere: Icons.upcoming),
              StdSpacedIconTextTab(
                  text: "Subscribed", iconHere: Icons.recent_actors_outlined),
            ],
          ),
          Expanded(
              child: Container(
                  child: const TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                EventSeriesList(
                  own: true,
                ),
                EventSeriesList(
                  own: false,
                )
              ])))
        ])));
  }
  /*            ExpansionTile(
              title: Text("EventSeriesInvitations"),
              children: [EventSeriesInvCard(essInv: state.esInv[0])],
            ),

   */
}
