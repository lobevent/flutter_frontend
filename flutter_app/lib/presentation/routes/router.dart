import 'package:auto_route/auto_route.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/event_form.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/event_screen_page.dart';
import 'package:flutter_frontend/presentation/pages/event/own_events/own_events_screen.dart';
import 'package:flutter_frontend/presentation/pages/feed.dart';
import 'package:flutter_frontend/presentation/pages/login/country_code_selection_screen.dart';
import 'package:flutter_frontend/presentation/pages/login/login_screen.dart';
import 'package:flutter_frontend/presentation/pages/login/phone_number_sign_in_screen.dart';
import 'package:flutter_frontend/presentation/pages/login/phone_number_verification_code_screen.dart';


@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: FeedScreen),
    AutoRoute(page: EventFormPage),
    AutoRoute(page: OwnEventsScreen),
    AutoRoute(page: LoginScreen, initial: true),
    AutoRoute(page: PhoneNumberSignInScreen),
    AutoRoute(page: CountryCodeSelectionScreen),
    AutoRoute(page: PhoneNumberVerificationCodeScreen),
    AutoRoute(page: EventScreenPage)
  ],
)
class $Router{}