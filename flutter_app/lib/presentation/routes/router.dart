import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_frontend/presentation/pages/event_form.dart';
import 'package:flutter_frontend/presentation/pages/feed.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: <AutoRoute>[
    MaterialRoute(page: FeedScreen, initial: true),
    MaterialRoute(page: EventFormPage)
  ],
)
class $Router {}