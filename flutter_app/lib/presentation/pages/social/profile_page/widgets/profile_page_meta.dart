import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/rotatingCircle.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/calender_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/cubit/profile_page_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../infrastructure/profile/achievements_dtos.dart';
import '../../../core/widgets/animations/loading_button.dart';
import '../../profile_score and achievements/profile_score_cubit.dart';

class ProfilePageMeta extends StatelessWidget {
  ///the color used to display the text on this page
  final Color textColor = Colors.black38;

  const ProfilePageMeta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
      builder: (context, state) {
        return state.maybeMap(
            loaded: (st) {
              // ConstrainedBox is for fin height of the Meta
              return ProfilePageMetaFull(context, st.profile);
            },
            orElse: () => Text(''));
      },
    );
  }

  Widget ProfilePageMetaFull(BuildContext context, Profile profile) {
    return ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 150.0,
          minWidth: 50.0,
        ),
        child: Column(children: [
          PaddingRowWidget(
            children: [TitleText(profile.name.getOrCrash())],
          ),
          // TODO: The unexpected Type Error comes when somone is not a friend yet. they cant load the full profile, but only the name and id. Fix to error message
          profile.map((value) => throw UnexpectedTypeError(),
              full: (profile) => EventAndFriends(profile.friendshipCount ?? 0,
                  profile.ownedEvents?.length, profile, context))
        ]));
  }

  /// A text widget, styled for headings
  Widget TitleText(String title) {
    return PaddingRowWidget(children: [
      Text(title,
          style: TextStyle(
            height: 2,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            //color: textColor
          ))
    ]);
  }

  /// Widget displays tags with the count of events and friends
  Widget EventAndFriends(int? friendscount, int? eventcount, Profile profile,
      BuildContext context) {
    return Column(
      children: [
        //our ProfileScore and Achievements
        ScoreAndAchievements(profile),

        PaddingRowWidget(children: [
          // Null friends is not tested yet. Maybe not working
          // The Friends Button
          TextWithIconButton(
              // On Pressed Navigate to the FriendsScreenRoute
              onPressed: () => context.router.push(ProfileFriendsScreenRoute()),
              text: " Friends: ${friendscount?.toString() ?? 0.toString()}",
              icon: Icons.emoji_people_outlined),

          Spacer(),
          //for the calender
          TextWithIconButton(
              onPressed: () => showOverlay(context, profile), text: 'Calender'),
          //TableCalendar(focusedDay: DateTime.now(), firstDay: DateTime.now(), lastDay: DateTime(2022, DateTime.september, 30)),
          // The Events Button
          Spacer(),

          TextWithIconButton(
              onPressed: () =>
                  context.router.push(EventUserPageRoute(profile: profile)),
              text: " Events: ${eventcount?.toString() ?? 0.toString()}",
              icon: Icons.tapas_outlined)
        ]),
      ],
    );
  }

  ///show Calender overlay
  void showOverlay(BuildContext buildContext, Profile profile) async {
    final OverlayState overlayState = Overlay.of(buildContext)!;

    //have to do it nullable
    OverlayEntry? overlayEntry;

    //this is the way to work with overlays
    overlayEntry = OverlayEntry(builder: (context) {
      return CalenderOverlay(context, overlayEntry!, profile);
    });
    overlayState.insert(overlayEntry);
  }

  ///our calender widget as overlay
  Widget CalenderOverlay(
      BuildContext context, OverlayEntry overlayEntry, Profile profile) {
    DateTime? _selectedDay;

    return DismissibleOverlay(
        overlayEntry: overlayEntry,
        child: Scaffold(
          body: CalenderWidget(
            overlayEntry: overlayEntry,
            profile: profile,
          ),
        ));
  }

  ///score widget for counting entries in box and displaying them as profile score
  Widget ScoreAndAchievements(Profile profile) {
    return BlocProvider(
      create: (context) => ProfileScoreCubit(
          profileId: profile.id,
          //check if its our own Profile and put it in state
          isOwnProfile: CommonHive.checkIfOwnId(profile.id.value.toString())),
      child: BlocBuilder<ProfileScoreCubit, ProfileScoreState>(
          builder: (context, state) {
        return state.maybeMap(loading: (st) {
          return Column(
            children: [
              AchievementTile(context),
              ScoreWidget(context, null, profile),
            ],
          );
        }, loaded: (st) {
          return Column(children: [
            AchievementTile(context, st.achievements),
            ScoreWidget(context, st.score, profile)
          ]);
        }, orElse: () {
          return ScoreWidget(context, null, profile);
        });
      }),
    );
  }

  /// achievements widget
  /// TODO: decide when we fetch or when we can use commonhive
  Widget AchievementTile(BuildContext context,
      [AchievementsDto? achievements]) {
    return ExpansionTile(
      title: Text("Achievements"),
      children: [Text(CommonHive.getAchievements().toString())],
    );
  }

  ///score widget fetchs score if its not our own profile, or it gets CommonHIve entry
  Widget ScoreWidget(BuildContext context, String? score, Profile profile) {
    //check if not own profile
    if (!context.read<ProfileScoreCubit>().isOwnProfile) {
      context.read<ProfileScoreCubit>().getProfileScore(profile);
    }
    return InkWell(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary),
        child: Center(
          child: score != null
              ? Text("Score:$score")
              : Text(
                  "Score: ${CommonHive.getBoxEntry<String>("profileScore", CommonHive.ownProfileIdAndPic) ?? "0"}",
                ),
        ),
      ),
      //update via ontap
      onTap: () {
        context.read<ProfileScoreCubit>().getProfileScore(profile);
      },
    );
  }
}
