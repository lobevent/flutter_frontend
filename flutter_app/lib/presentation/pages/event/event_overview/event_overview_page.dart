import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/widgets/eop_tab_bar_view.dart';

class EventOverviewPage extends StatelessWidget {
  const EventOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return BasicContentContainer(
          bottomNavigationBar: BottomNavigation(selected: NavigationOptions.eventOverview,),
          child_ren: right(

              DefaultTabController(
                  length: 3,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [

                    // ------------------------------------------------------------------------------------------------------------------
                    // ------------------------------------------- here the TabBar and the Tabview --------------------------------------
                    // ------------------------------------------------------------------------------------------------------------------
                    EOPTabBar(),
                    EventOverviewTabBarView()
                  ]))

      ));
  }

  Widget EOPTabBar(){
    return  const TabBar(
      indicatorColor: AppColors.stdIndicatedTabColor,
      tabs: [
        Tab(child: Text(AppStrings.attending), icon: Icon(Icons.check_rounded),),
        Tab(child: Text(AppStrings.invited), icon: Icon(Icons.mail),),
        Tab(child: Text(AppStrings.local), icon: Icon(Icons.location_on_outlined),),
      ],
    );
  }




}
