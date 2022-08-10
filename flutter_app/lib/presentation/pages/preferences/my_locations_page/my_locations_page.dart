import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/list_tiles/my_location_tile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Overlays/my_location_form/my_location_form_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/preferences/my_locations_page/cubit/my_locations_cubit.dart';

class MyLocationsPage extends StatelessWidget {
  const MyLocationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BasicContentContainer(
      scrollable: true,
        child_ren: right(
      BlocProvider(create: (context) => MyLocationsCubit(),
        child: BlocBuilder<MyLocationsCubit, MyLocationsState>(
          builder: (context, state) {
            if(state is MyLocationsLoading){
              return Row(children: [Spacer(), Column(children: [Spacer(), CircularProgressIndicator(),Spacer()],), Spacer()]);
            } else if(state is MyLocationsLoaded){
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                          _buildListView(state),
                         //this is added due to the button in the bottom, so that the last location is good visible
                         SizedBox(height: 50,)
                      ],
                    ),
                  ),
                  // The Positioned Button
                  Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: IconButton(onPressed: () => MyLocationFormOverlay(context: context), icon: Icon(Icons.add))),
                ],
              );
            }
              return Spacer();
          },
        )
      )

    ));
  }

  //--------------------------------------------------------------------------------------------------------------------------------------------------
  //---------------------------------------------------------------Private Widgets--------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------------------------------

  /// Generates Listview of the Locations
  /// [state] is the state of the cubit, it contains the locations
  /// The Listview is not scrollable
  ListView _buildListView(MyLocationsLoaded state) {
    return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: (state).myLocations.length,
                              itemBuilder: (context, index) => MyLocationTile(location: state.myLocations[index],
                              onDelete: context.read<MyLocationsCubit>().deleteMyLocation),
                        separatorBuilder: (context, index)=> const Divider(height: 1, thickness: 1,),);
  }
  
  
}
