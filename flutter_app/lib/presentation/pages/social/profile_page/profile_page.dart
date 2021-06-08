

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/application/profile/profile_page/profile_page_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/widgets/profile_page_body.dart';

class ProfilePage extends StatelessWidget{

  final UniqueId profileId;
  const ProfilePage({Key? key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilePageCubit(profileId: profileId),
      child: _generateBody(),
    );
  }


  Widget _generateBody(){
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: BlocBuilder<ProfilePageCubit, ProfilePageState>(
        builder: (context, state){
          return Stack(
            children: <Widget>[
            //   state.maybeMap(
            //     loaded: (loadState) =>  ProfilePageBody(profileFailureOption: some(left(loadState.profile))),
            //     error: (errState) => ProfilePageBody(profileFailureOption: some(right(errState.error)),
            //     orElse: () => ProfilePageBody(profileFailureOption: none())),
            // LoadingOverlay(isLoading: state is LoadInProgress, text: "Loading")
          ],
        );
        },
      )
    );
  }

}