import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

enum NavigationOptions {
  home,
  ownEvents,
  invited,
  ownProfile,
  login,
  profileSearch,
  friends,
  addEvent,
  imageUpload,
  eventSwiper,
}

class BottomNavigation extends StatelessWidget {
  static Map enumToData = {
    NavigationOptions.home: {'key': 0, 'route': FeedScreenRoute()},
    NavigationOptions.ownEvents: {
      'key': 1,
      'route': EventsMultilistScreenRoute()
    },
    NavigationOptions.profileSearch: {
      'key': 2,
      'route': ProfileSearchPageRoute()
    },
    NavigationOptions.eventSwiper: {'key': 3, 'route': EventSwiperRoute()},
  };

  static final indexToEnum =
      enumToData.map((key, value) => MapEntry(value['key'], key));

  final Function(NavigationOptions)? onItemTapped;
  final NavigationOptions selected;

  const BottomNavigation({Key? key, required this.selected, this.onItemTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: AppColors.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'OwnEvents',
          backgroundColor: AppColors.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_search),
          label: 'ProfileSearch',
          backgroundColor: AppColors.primaryColor,
        ),
        //logout
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.login),
        //   label: 'login',
        //   backgroundColor: Colors.blue,
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz_outlined),
          label: 'EventSwiper',
          backgroundColor: AppColors.primaryColor,
        ),
      ],
      currentIndex: enumToData[selected]['key'] as int,
      selectedItemColor: AppColors.mainIcon,
      onTap: (index) => onItemTapped != null
          ? onItemTapped!(indexToEnum[index] as NavigationOptions)
          : navigate(indexToEnum[index] as NavigationOptions, context),
    );
  }

  void navigate(NavigationOptions where, BuildContext context) async {
    context.router.push(enumToData[where]['route'] as PageRouteInfo);
  }
}
