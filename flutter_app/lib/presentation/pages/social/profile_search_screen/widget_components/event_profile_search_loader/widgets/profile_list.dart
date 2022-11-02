import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/event/core/profile_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widget_components/event_profile_search_loader/cubit_epsl/event_profile_search_loader_cubit.dart';

class SearchProfileList extends StatelessWidget {
  const SearchProfileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventProfileSearchLoaderCubit<Profile>, EventProfileSearchLoaderState<Profile>>(
        builder: (context, state){
          return ListView.builder(
              itemCount: state.enities.length,
              itemBuilder: (context, index){
                return ProfileListTiles(profile: state.enities[index], key: ObjectKey(state.enities[index]),);
              });
        }
    );
  }
}
