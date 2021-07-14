import 'package:auto_route/auto_route.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/event_form.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/event_screen_page.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/events_multilist_screen.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/widgets/item_create_widget.dart';
import 'package:flutter_frontend/presentation/pages/feed.dart';
import 'package:flutter_frontend/presentation/pages/login/country_code_selection_screen.dart';
import 'package:flutter_frontend/presentation/pages/login/login_screen.dart';
import 'package:flutter_frontend/presentation/pages/login/phone_number_sign_in_screen.dart';
import 'package:flutter_frontend/presentation/pages/login/phone_number_verification_code_screen.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_friends/profile_friends_page.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/profile_page.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search/profile_search_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: FeedScreen, initial: true),
    AutoRoute(page: EventFormPage),
    AutoRoute(page: EventsMultilistScreen),
    AutoRoute(page: ItemCreateWidget),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: PhoneNumberSignInScreen),
    AutoRoute(page: CountryCodeSelectionScreen),
    AutoRoute(page: PhoneNumberVerificationCodeScreen),
    AutoRoute(page: EventScreenPage),
    AutoRoute(page: ProfilePage),
    AutoRoute(page: ProfileSearchPage),
    AutoRoute(page: ProfileFriendsScreen)
  ],
)
class $Router {}
