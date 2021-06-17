import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_search/profile_search_cubit.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/event/core/profile_list_tiles.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';


class SearchResultsListView extends StatefulWidget {
  @override
  SearchResultsListViewState createState() => SearchResultsListViewState();
}

class SearchResultsListViewState extends State<SearchResultsListView> {
  String? searchTerm;
  List<Profile> profiles = [];


  @override
  Widget build(BuildContext context) {
    //return normal search overlay
    /*if(searchTerm==null){
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Start searching',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }
     */
    final fsb = FloatingSearchBar.of(context);
    return BlocListener<ProfileSearchCubit, ProfileSearchState>(
      listener: (context, state) => {
        state.maybeMap(
            loaded: (state) =>
            {this.profiles = state.profiles, setState(() {})},
            orElse: () => {})
      },
      child:
      ListView.builder(
        // build under the floatingsearchbar
          padding: EdgeInsets.only(top: fsb!.value.height + fsb.value.margins.vertical),
          itemBuilder: (context, index) {
            final profile = this.profiles[index];
            if (profile.failureOption.isSome()) {
              //red tile if profile failure
              return ClipRect(
                child: Ink(
                  color: Colors.red,
                  child: ListTile(
                    title: Text(profile.failureOption
                        .fold(() => "", (a) => a.toString())),
                  ),
                ),
              );
            }
            if (this.profiles.isEmpty) {
              return ClipRect(
                child:Ink(
                  color: Colors.red,
                  child: ListTile(
                    title: Text("No profiles Found"),
                  ),
                ),
              );
            } else {
              ///return profilelisttiles as searched
              return ClipRect(
                child: ProfileListTiles(
                    key: ObjectKey(profile), profile: this.profiles[index]),
              );
            }
          },
          itemCount: this.profiles.length),
    );
  }

}
