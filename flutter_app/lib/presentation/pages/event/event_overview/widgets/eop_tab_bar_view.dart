import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/main_bloc/event_overview_bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_basic/cubit__eop_single_tab_basic/eop_single_tab_basic_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_basic/eop_single_tab_basic_list.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_distances/cubit__eop_single_tab_distances/eop_single_tab_distances_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_distances/eop_single_tab_distances_list.dart';

class EventOverviewTabBarView extends StatefulWidget {
  const EventOverviewTabBarView({Key? key}) : super(key: key);

  @override
  State<EventOverviewTabBarView> createState() => _EventOverviewTabBarViewState();
}

class _EventOverviewTabBarViewState extends State<EventOverviewTabBarView> {
  ///
  /// [isRecent] shows what cubit to use for showing the overview
  ///
  bool isRecent = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventOverviewBloc, EventOverviewState>(
      listener: (context, state) {
        setState(() {
          isRecent = state.status == MainStatus.recent;
        });
      },
      child: Expanded(child: Container(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (BuildContext context) => InvitedEOPSingleTabCubit(),),
              BlocProvider(create: (BuildContext context) => AttendingEOPSingleTabCubit(),),
              BlocProvider(create: (BuildContext context) => EopSingleTabDistancesCubitUpcoming(),),
              // ---------------------------- from here the recent cubits ---------------------------
              BlocProvider(create: (BuildContext context) => Recent_AttendingEOPSingleTabCubit(),),
              BlocProvider(create: (BuildContext context) => Recent_InvitedEOPSingleTabCubit(),),
              BlocProvider(create: (BuildContext context) => Recent_EopSingleTabDistancesCubit(),),
            ],
            child: TabBarView(
                children: isRecent ? recentTabs() : upcomingTabs()
            ),
          )
      )
      ),
    );
  }

  List<Widget> upcomingTabs(){
    return const [
      SingleTabBasicEventOverview<AttendingEOPSingleTabCubit>(attending: true,),
      SingleTabBasicEventOverview<InvitedEOPSingleTabCubit>(attending: false,),
      SingleTabDistancesEventOverview<EopSingleTabDistancesCubitUpcoming>()
    ];
  }

  List<Widget> recentTabs(){
    return const [
      SingleTabBasicEventOverview<Recent_AttendingEOPSingleTabCubit>(attending: true,),
      SingleTabBasicEventOverview<Recent_InvitedEOPSingleTabCubit>(attending: false,),
      SingleTabDistancesEventOverview<Recent_EopSingleTabDistancesCubit>()
    ];
  }

}
