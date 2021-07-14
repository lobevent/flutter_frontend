import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_friends/profile_friends_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/alert_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_friends/widgets/profile_friends_body.dart';

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
            bool isLoading = state.maybeMap((initial) => false,
                loading: (_) => true, orElse: () => false);
            return LoadingOverlay(
                isLoading: isLoading, child: ProfileFriendsScreenHolder());
          }),
    );
  }
}

class ProfileFriendsScreenHolder extends StatelessWidget {
  ProfileFriendsScreenHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Friends"),
        ),
        body: ProfileFriendsBody());
  }
}
