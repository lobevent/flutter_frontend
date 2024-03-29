import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/main_app_bar.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/cubit/main_profile_search_cubit.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_search_screen/widgets/pspm_activatable_textarea.dart';

import 'widget_components/event_profile_search_loader/event_profile_search_loader_container.dart';

class ProfileSearchPageMain extends StatelessWidget {
  const ProfileSearchPageMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasicContentContainer(
        appBar: MainAppBar(),
        bottomNavigationBar: BottomNavigation(selected: NavigationOptions.profileSearch,),
        child_ren: right(
            BlocProvider(
              create: (context) => MainProfileSearchCubit(),
              child: BlocBuilder<MainProfileSearchCubit, MainProfileSearchState>(
                builder: (context, state){
                  return BackButtonListener(
                    onBackButtonPressed: () => context.read<MainProfileSearchCubit>().backButtonPressed(),
                    child: Stack(children: [
                      deciderSearchOrSuggestions(state),
                      ActivatableTextarea(),
                    ],),
                  );
                  },
              ),
            )
        ));
  }

  /// decides whether to display the results of the page or the discovery page
  /// depends on [state] to determine
  Widget deciderSearchOrSuggestions(MainProfileSearchState state){
    if(state.status == PSStatus.searchSubmitted && state.searchString != null){
      return EventProfileSearchLoaderContainer(searchString: state.searchString!, key: ObjectKey(state.searchString),);
    }else{
      return SuggestionsBuilder();
    }
  }


  Widget SuggestionsBuilder(){
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: ListView.builder(
          itemCount: 50,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${index}'),
            );
          }),
    );
  }
}
