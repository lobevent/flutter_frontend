import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_page/profile_page_cubit.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_widget.dart';

class ProfilePagePosts extends StatelessWidget{
  const ProfilePagePosts({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageCubit, ProfilePageState>(
      builder: (context, state){
        ///map the state
        return state.maybeMap(
            loaded: (profileState){
              // if we have the loaded state, map over the profile
              // profile has the base profile (list view) and an full profile
              return profileState.profile.map(
                  //if we have base(list) profile, we dont show anything
                      (value) => Text(""),
                  // if we have the correct full profile, build the list
                  full: (profile) {
                        return PostList(profile.posts!);
                  });
            },
            orElse: () => Text(""));
      },
    );
  }


  /// generate list of posts
  Widget PostList(List<Post> posts){
    return Container(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index){
              return PostWidget(post: posts[index]);
      },
    ));
  }
}