import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/list_tiles/my_location_tile.dart';
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
              return CircularProgressIndicator();
            } else if(state is MyLocationsLoaded){
              return ListView.builder(
                      itemCount: (state).myLocations.length,
                      itemBuilder: (context, index) => Column(children: [
                        MyLocationTile(location: state.myLocations[index],
                        onDelete: context.read<MyLocationsCubit>().deleteMyLocation),
                        Divider()]));
            }
              return Spacer();
          },
        )
      )

    ));
  }
}
