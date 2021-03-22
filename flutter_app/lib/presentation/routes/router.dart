import 'package:auto_route/auto_route.dart';
import 'package:flutter_frontend/presentation/pages/Event/Event_Form/event_form.dart';
import 'package:flutter_frontend/presentation/pages/feed.dart';
import 'package:flutter_frontend/presentation/pages/own_events_screen.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: <AutoRoute>[
    AutoRoute(page: FeedScreen, initial: true),
    AutoRoute(page: EventFormPage),
    AutoRoute(page: OwnEventsScreen)
  ],
)
class $Router {}