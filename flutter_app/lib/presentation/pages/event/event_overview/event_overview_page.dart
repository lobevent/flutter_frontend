import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/main_app_bar.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/main_bloc/event_overview_bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_tab_bar_view.dart';

class EventOverviewPage extends StatelessWidget {
  const EventOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ************************** BLOC STUFF ********************************
    // ----------------------------------------------------------------------
    return BlocProvider(// --------------------------------------------------
      create: (context) => EventOverviewBloc(),// ---------------------------
      child: BlocBuilder<EventOverviewBloc, EventOverviewState>(// ----------
        builder: (context, state) {// ---------------------------------------
    // ----------------------------------------------------------------------

          return BasicContentContainer(
                            bottomNavigationBar: BottomNavigation(selected: NavigationOptions.eventOverview,),
              child_ren: right(

                  DefaultTabController(
                      length: 3,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [

                        // ------------------------------------------------------------------------------------------------------------------
                        // ------------------------------------------- here the TabBar and the Tabview --------------------------------------
                        // ------------------------------------------------------------------------------------------------------------------

                        _EOPTabBar(state),
                        _actionsContainer(context, state),
                        EventOverviewTabBarView()
                      ]))

              ));

        },// ----------------------------------------------
      ),// ------------------------------------------------
    );// --------------------------------------------------
  }


  Widget _actionsContainer(BuildContext context, EventOverviewState state){
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(width: 3))),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _recentSwitcherButton(context, state),
          _showDeclined(context, state),
        ],
      ),
    );
  }

  Widget _recentSwitcherButton(BuildContext context, EventOverviewState state){
    return IconButton(
      splashRadius: 20,
      icon: Icon(Icons.ac_unit),
      onPressed: () => context.read<EventOverviewBloc>().add(state.status == MainStatus.upcoming ?
      EventOverviewShowRecent() :
      EventOverviewShowUpcomming()),);
  }

  Widget _showDeclined(BuildContext context, EventOverviewState state){
    return IconButton(
      splashRadius: 20,
      icon: Icon(AppIcons.notAttending),
      onPressed: () => context.read<EventOverviewBloc>().add(state.status == MainStatus.upcoming ?
      EventOverviewShowRecent() :
      EventOverviewShowUpcomming()),);
  }

  Widget _EOPTabBar(EventOverviewState state) {
    bool isRecent = state.status == MainStatus.recent;
    return TabBar(
      labelColor: isRecent ? AppColors.accentButtonColor : null,
      indicatorColor: AppColors.stdIndicatedTabColor,
      tabs: [
        Tab(child: Text(isRecent ? AppStrings.attended : AppStrings.attending), icon: Icon(Icons.check_rounded),),
        Tab(child: Text(AppStrings.invited), icon: Icon(Icons.mail),),
        Tab(child: Text(AppStrings.local), icon: Icon(Icons.location_on_outlined),),
      ],
    );
  }


}
