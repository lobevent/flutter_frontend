import 'package:dartz/dartz.dart' show Either, left, right;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_friends/widgets/profile_friends_body.dart';

import 'cubit/profile_friends_cubit.dart';

class ProfileFriendsScreen extends StatefulWidget {
  final UniqueId? profileId;

  const ProfileFriendsScreen({Key? key, this.profileId}) : super(key: key);

  @override
  _ProfileFriendsScreenState createState() => _ProfileFriendsScreenState();
}

class _ProfileFriendsScreenState extends State<ProfileFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileFriendsCubit(widget.profileId),
      child: BlocConsumer<ProfileFriendsCubit, ProfileFriendsState>(
          listener: (context, state) => {},
          builder: (context, state) {
            return BasicContentContainer(
              isLoading: state is LoadInProgress,
              child_ren: right(ProfileFriendsBody()),
              scrollable: false,
            );
          }),
    );
  }
}
