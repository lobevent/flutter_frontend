import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_search/profile_search_cubit.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/pages/core/widgets/image_classes.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';




class ProfileListTiles extends StatelessWidget {
  final Profile profile;
  final String? imagePath;

  const ProfileListTiles({required ObjectKey key, required this.profile, String? this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSearchCubit, ProfileSearchState>(
        builder: (context, state){
          return Card(
              child: ListTile(

                leading: IconButton(
                  icon: CircleAvatar(radius: 30,
                    backgroundImage: ProfileImage.getAssetOrNetwork(imagePath),),
                  onPressed: () => showProfile(context),
                ),
                title: Text(profile.name.getOrCrash()),
                trailing: Row(
                  children: [
                    IconButton(
                        onPressed: () => context.read<ProfileSearchCubit>().sendFriendship(profile.id),
                        icon: Icon(Icons.person_add_alt_1_rounded))
                  ],
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ));
          throw UnimplementedError();
        }
    );
  }

  void showProfile(BuildContext context) {
    context.router.push(ProfilePageRoute(profileId: profile.id));
  }

}
