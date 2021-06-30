

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/application/profile/profile_page/profile_page_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_screen.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/widgets/profile_page_meta.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/widgets/profile_page_header_visual.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/widgets/profile_page_posts.dart';

/// the page for displaying profile information in social context
/// (not settings page)
class ProfilePage extends StatelessWidget {

  /// the profileId is used to fetch the profile an it is required by this page
  final UniqueId profileId;

  const ProfilePage({Key? key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfilePageCubit(profileId: profileId),
      ///the blocbuilder is needed to determine the state class
      ///to determine what to show (errormessage, loadingoverlay or content)
      /// this part of the class therefore contains logic
      child: BlocBuilder<ProfilePageCubit, ProfilePageState>(
        builder: (context, state) {
          ///the loading Overlay wraps the whole tree
          return LoadingOverlay(
              isLoading: state is ProfileLoadInProgress,
              child:
                /// check if an error has occured and show error message in that case
                /// wrapped in a list to match closure context
                BasicContentContainer(
                    scrollable: false,
                    children:
                    state.maybeMap(
                      /// if the error state is not active, load the contents
                        error: (errState) =>[ErrorMessage(errorText: errState.error)],
                        orElse: () =>
                        const [
                          // the profile image
                          ProfilePageHeaderVisual(),
                          ProfilePageMeta(),
                          ProfilePagePosts(),
                        ]
                    )
                )
          );
        },
      ),
    );
  }
}