import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_page/profile_page_cubit.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_screen.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/widgets/profile_page_name.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class ProfilePageMeta extends StatelessWidget {
  ///the color used to display the text on this page
  final Color textColor = Colors.black38;

  const ProfilePageMeta( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
      builder: (context, state){
          return state.maybeMap(
              loaded: (st) =>
              ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 150.0,
                    minWidth: 50.0,
                  ),
              child:
                Column(
                    children: [
                      PaddingRowWidget(
                        children: [
                          TitleText(st.profile.name.getOrCrash())
                        ],
                      ),
                      st.profile.map((value) => throw UnexpectedTypeError(), full: (profile) =>
                        EventAndFriends(profile.friendshipCount?? 0, profile.ownedEvents?.length, context)
                      )
                ]
                )
              ),
              orElse: () => Text('')
          );
      },
    );
  }



  /// A text widget, styled for headings
  Widget TitleText(String title){
    return PaddingRowWidget(
        children: [
          Text(title, style: TextStyle(height: 2, fontSize: 30,
              fontWeight: FontWeight.bold, color: textColor))
        ]
    );
  }


  /// Widget displays tags with the count of events and friends
  Widget EventAndFriends(int? friendscount, int? eventcount, BuildContext context){


    return PaddingRowWidget(
        children: [
          StdTextButton(
            onPressed: () =>  context.router.push(ProfileFriendsScreenRoute()),
            child: Row(children: [
              const Icon(
                Icons.emoji_people_outlined,
                color: AppColors.stdTextColor,
              ),
              Text(" Friends: ", style: TextStyle(color: AppColors.stdTextColor),),
              Text(friendscount?.toString()?? 0.toString(), style: TextStyle(color: AppColors.stdTextColor)),
            ],),)

          ,
          Spacer(),
          StdTextButton(
            onPressed: null,
            child: Row(children: [
              const Icon(
                Icons.tapas_outlined,
                color: AppColors.stdTextColor,
              ),
              Text(" Events: ", style: TextStyle(color: AppColors.stdTextColor),),
              Text(eventcount?.toString()?? 0.toString(), style: TextStyle(color: AppColors.stdTextColor)),
            ],),)


    ]);
  }
}

