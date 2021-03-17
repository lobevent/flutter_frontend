import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_frontend/presentation/pages/Event/Event_Form/event_form.dart';
import 'package:flutter_frontend/presentation/pages/feed.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: <AutoRoute>[
    AutoRoute(page: FeedScreen, initial: true),
    AutoRoute(page: EventFormPage)
  ],
)
class $Router {}