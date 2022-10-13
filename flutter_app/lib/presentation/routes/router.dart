import 'package:auto_route/auto_route.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Overlays/my_location_form/my_location_form_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Profile/ProfileImagePickerWidget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';
import 'package:flutter_frontend/presentation/pages/event/event_overview/event_overview_page.dart';
import 'package:flutter_frontend/presentation/pages/event/event_profile_pictures_page/epp_page.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/event_series_form_main.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/ess_page.dart';
import 'package:flutter_frontend/presentation/pages/event/event_swiper/event_swiper.dart';
import 'package:flutter_frontend/presentation/pages/event/events_user/events_user_page.dart';
import 'package:flutter_frontend/presentation/pages/event/eventseries_list/esl_page.dart';
import 'package:flutter_frontend/presentation/pages/login_register_email/registration_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/event_form.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/event_screen_page.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/Overlays/es_ol_item_create_form.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/events_multilist_screen.dart';
import 'package:flutter_frontend/presentation/pages/feed/feed.dart';
import 'package:flutter_frontend/presentation/pages/login/country_code_selection_screen.dart';
import 'package:flutter_frontend/presentation/pages/login/login_screen.dart';
import 'package:flutter_frontend/presentation/pages/login/phone_number_sign_in_screen.dart';
import 'package:flutter_frontend/presentation/pages/login/phone_number_verification_code_screen.dart';
import 'package:flutter_frontend/presentation/pages/login_register_email/login_register.dart';
import 'package:flutter_frontend/presentation/pages/preferences/my_locations_page/my_locations_page.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_friends/profile_friends_page.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/profile_page.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search/profile_search_page.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/comments_screen.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/post_screen.dart';

@MaterialAutoRouter(
  routes: [
    AutoRoute(path: '/', page: FeedScreen, initial: true),
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
    AutoRoute(page: ProfileFriendsScreen),
    AutoRoute(page: CommentsScreen),
    AutoRoute(page: PostsScreen),
    AutoRoute(page: LoginRegister),
    AutoRoute(page: ImageUpload),
    AutoRoute(page: RegistrationForm),
    AutoRoute(page: ProfileImagePickerWidget),
    AutoRoute(page: EventSwiper),
    CustomRoute(page: EventSeriesFormMain, transitionsBuilder: TransitionsBuilders.fadeIn, durationInMilliseconds: 400),
    AutoRoute(page: EventSeriesListPage),
    AutoRoute(page: EventSeriesScreenPage),
    AutoRoute(page: MyLocationsPage),
    AutoRoute(page: MyLocationForm),
    AutoRoute(page: EPPPage),
    AutoRoute(page: EventUserPage),
    AutoRoute(page: EventOverviewPage)
  ],
)
class $Router {}
