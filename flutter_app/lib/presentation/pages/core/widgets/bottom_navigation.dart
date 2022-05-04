import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart' hide Router;
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
    NavigationOptions.invited: {
      'key': 2,
      'route': EventsMultilistScreenRoute(option: EventScreenOptions.invited)
    },
    NavigationOptions.ownProfile: {
      'key': 3,
      'route': ProfilePageRoute(profileId: UniqueId.fromUniqueString(""))
    },
    NavigationOptions.profileSearch: {
      'key': 4,
      'route': ProfileSearchPageRoute()
    },
    NavigationOptions.login: {'key': 5, 'route': LoginRegisterRoute()},
    NavigationOptions.friends: {'key': 6, 'route': ProfileFriendsScreenRoute()},
    NavigationOptions.addEvent: {'key': 7, 'route': EventFormPageRoute()},
    NavigationOptions.imageUpload: {'key': 8, 'route': ImageUploadRoute()},
    NavigationOptions.eventSwiper: {'key': 9, 'route': EventSwiperRoute()},
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
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'OwnEvents',
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_available),
          label: 'Invited',
          backgroundColor: Colors.purple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'OwnProfile',
          backgroundColor: Colors.pink,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_search),
          label: 'ProfileSearch',
          backgroundColor: Colors.brown,
        ),
        //logout
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'login',
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Friends',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'AddEvent',
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.upload_rounded),
          label: 'ImageUpload',
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz_outlined),
          label: 'EventSwiper',
          backgroundColor: Colors.brown,
        ),
      ],
      currentIndex: enumToData[selected]['key'] as int,
      selectedItemColor: Colors.amber[800],
      onTap: (index) => onItemTapped != null
          ? onItemTapped!(indexToEnum[index] as NavigationOptions)
          : navigate(indexToEnum[index] as NavigationOptions, context),
    );
  }

  void navigate(NavigationOptions where, BuildContext context) async {
    //index  4 is logout so ask if really wants to log out
    if (where.index == 4) {
      await GenDialog.genericDialog(context, "Logout?",
              "Willst du dich wirklich ausloggen?", "Logout", "Abbrechen")
          .then((value) async => {
                if (value)
                  context.router
                      .push(enumToData[where]['route'] as PageRouteInfo)
                else
                  {}
              });
    } else {
      context.router.push(enumToData[where]['route'] as PageRouteInfo);
    }
  }
}
