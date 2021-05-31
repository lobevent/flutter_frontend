

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_page/profile_page_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

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
          title: Text("Own Events"),
        ),
        body: BlocBuilder<ProfilePageCubit, ProfilePageState>(
        builder: (context, state) {
          return state.map(loaded: (state) => Text(state.profile.name.getOrCrash()),
          initial: (state) => Text("loading"),
          error: (state) => Text("error"));
        },
      )
    );
  }

}