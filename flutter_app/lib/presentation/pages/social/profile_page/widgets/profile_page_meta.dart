
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_page/profile_page_cubit.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/events_mulitlist/events_mulitlist_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class ProfilePageMeta extends StatelessWidget {
  ///the color used to display the text on this page
  final Color textColor = Colors.black38;

  const ProfilePageMeta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
      builder: (context, state) {
        return state.maybeMap(
            loaded: (st) =>
                // ConstrainedBox is for fin height of the Meta
                ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 150.0,
                      minWidth: 50.0,
                    ),
                    child: Column(children: [
                      PaddingRowWidget(
                        children: [TitleText(st.profile.name.getOrCrash())],
                      ),
                      // TODO: The unexpected Type Error comes when somone is not a friend yet. they cant load the full profile, but only the name and id. Fix to error message
                      st.profile.map((value) => throw UnexpectedTypeError(),
                          full: (profile) => EventAndFriends(
                              profile.friendshipCount ?? 0,
                              profile.ownedEvents?.length,
                              profile,
                              context))
                    ])),
            orElse: () => Text(''));
      },
    );
  }

  /// A text widget, styled for headings
  Widget TitleText(String title) {
    return PaddingRowWidget(children: [
      Text(title,
          style: TextStyle(
              height: 2,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: textColor))
    ]);
  }

  /// Widget displays tags with the count of events and friends
  Widget EventAndFriends(int? friendscount, int? eventcount, Profile profile,
      BuildContext context) {
    return PaddingRowWidget(children: [
      // Null friends is not tested yet. Maybe not working
      // The Friends Button
      TextWithIconButton(
          // On Pressed Navigate to the FriendsScreenRoute
          onPressed: () => context.router.push(ProfileFriendsScreenRoute()),
          text: " Friends: ${friendscount?.toString() ?? 0.toString()}",
          icon: Icons.emoji_people_outlined),

/*          StdTextButton(
            onPressed: () =>  context.router.push(ProfileFriendsScreenRoute()),
            child: Row(children: [
              const Icon(
                Icons.emoji_people_outlined,
                color: AppColors.stdTextColor,
              ),
              // divide in two texts, as count could be null, and the whole thing isnt diplayed
              Text(" Friends: ", style: TextStyle(color: AppColors.stdTextColor),),
              Text(friendscount?.toString()?? 0.toString(), style: TextStyle(color: AppColors.stdTextColor)),
            ],),)

          ,*/
      Spacer(),
      // The Events Button
      TextWithIconButton(
          onPressed: () => context.router.push(EventsMultilistScreenRoute(
              option: EventScreenOptions.fromUser, profile: profile)),
          text: " Events: ${eventcount?.toString() ?? 0.toString()}",
          icon: Icons.tapas_outlined)

/*          StdTextButton(
            onPressed: () => context.router.push(EventsMultilistScreenRoute(option: EventScreenOptions.fromUser, profile: profile )),
            child: Row(children: [
              const Icon(
                Icons.tapas_outlined,
                color: AppColors.stdTextColor,
              ),
              // divide in two texts, as count could be null, and the whole thing isnt diplayed
              Text(" Events: ", style: TextStyle(color: AppColors.stdTextColor),),
              Text(eventcount?.toString()?? 0.toString(), style: TextStyle(color: AppColors.stdTextColor)),
            ],),)*/
    ]);
  }
}
