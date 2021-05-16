

import 'package:flutter/cupertino.dart';
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
      child: BlocBuilder<ProfilePageCubit, ProfilePageState>(
        builder: (context, state) {
          return state.maybeMap(loaded: (state) => Text(state.profile.name.getOrCrash()),
          orElse: () => Text("error"));
        },
      )
    );
  }

}