import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_page/profile_page_cubit.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_screen.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/widgets/profile_page_name.dart';

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
                        EventAndFriends(profile.friendships?.length, profile.ownedEvents?.length)
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


  Widget EventAndFriends(int? friendscount, int? eventcount){
    return PaddingRowWidget(
        children: [
          DecoratedBox(
              decoration: BoxDecoration(
                  color: Color(0x2ABBBBBB),
               /*   border:Border.all(width: 2.0,
                  color:  Color(0x6BBBBBBB)),*/
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent)),
                onPressed: () => null,
                child: Row(children: [
                  Text("Friends: ", style: TextStyle(color: AppColors.stdTextColor),),
                  Text(friendscount?.toString()?? 0.toString(), style: TextStyle(color: AppColors.stdTextColor)),
                ],)))

          ,
          Spacer(),
          Text(eventcount?.toString()?? 0.toString())

    ]);
  }
}

