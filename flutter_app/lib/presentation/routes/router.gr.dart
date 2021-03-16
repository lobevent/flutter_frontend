// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/event/event.dart';
import '../pages/event_form.dart';
import '../pages/feed.dart';

class Routes {
  static const String feedScreen = '/';
  static const String eventFormPage = '/event-form-page';
  static const all = <String>{
    feedScreen,
    eventFormPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.feedScreen, page: FeedScreen),
    RouteDef(Routes.eventFormPage, page: EventFormPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    FeedScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => FeedScreen(),
        settings: data,
      );
    },
    EventFormPage: (data) {
      final args = data.getArgs<EventFormPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => EventFormPage(
          key: args.key,
          editedEvent: args.editedEvent,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Navigation helper methods extension
/// *************************************************************************

extension RouterExtendedNavigatorStateX on ExtendedNavigatorState {
  Future<dynamic> pushFeedScreen() => push<dynamic>(Routes.feedScreen);

  Future<dynamic> pushEventFormPage({
    Key key,
    @required Event editedEvent,
  }) =>
      push<dynamic>(
        Routes.eventFormPage,
        arguments: EventFormPageArguments(key: key, editedEvent: editedEvent),
      );
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// EventFormPage arguments holder class
class EventFormPageArguments {
  final Key key;
  final Event editedEvent;
  EventFormPageArguments({this.key, @required this.editedEvent});
}
