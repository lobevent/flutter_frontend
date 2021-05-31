import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_page/profile_page_cubit.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_screen.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/widgets/profile_page_name.dart';

class ProfilePageBody extends StatelessWidget {
  final Option<Either<Profile, String>> profileFailureOption;
  const ProfilePageBody( {Key? key, required this.profileFailureOption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Event")
        ),
        body: profileFailureOption.fold(
                () => Center(),
                (some) => some.fold((profile) =>
                SingleChildScrollView(
                  child: Column(
                    children: [
                      //ProfileScreenName(name: profile.name),
                    ],
                  ),
                ),
                    (failure) => ErrorScreen(fail: failure.runtimeType.toString()))
        )
    );
  }
}

