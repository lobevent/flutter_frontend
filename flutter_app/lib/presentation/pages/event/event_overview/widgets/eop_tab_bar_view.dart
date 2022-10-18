import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_basic/cubit__eop_single_tab_basic/eop_single_tab_basic_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_basic/eop_single_tab_basic_list.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_distances/cubit__eop_single_tab_distances/eop_single_tab_distances_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_single_tab_distances/eop_single_tab_distances_list.dart';

class EventOverviewTabBarView extends StatelessWidget {
  const EventOverviewTabBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Expanded(child: Container(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (BuildContext context) =>  InvitedEOPSingleTabCubit(),),
              BlocProvider(create: (BuildContext context) =>  AttendingEOPSingleTabCubit(),),
              BlocProvider(create: (BuildContext context) =>  EopSingleTabDistancesCubit(),),
            ],
            child: const TabBarView(
                children: [
                  SingleTabBasicEventOverview<AttendingEOPSingleTabCubit>(attending: true, ),
                  SingleTabBasicEventOverview<InvitedEOPSingleTabCubit>(attending: false,),
                  SingleTabDistancesEventOverview()
                ]
                ),
          )
          )
      );
  }

}
