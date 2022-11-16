import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/list_tiles/my_location_tile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Overlays/my_location_form/my_location_form_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/preferences/my_locations_page/cubit/my_locations_cubit.dart';

// https://www.kodeco.com/33302203-overlays-in-flutter-getting-started


class MyLocationsPage extends StatelessWidget {
  const MyLocationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BasicContentContainer(
        child_ren: right(
      BlocProvider(create: (context) => MyLocationsCubit(),
        child: BlocBuilder<MyLocationsCubit, MyLocationsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => _reload(context),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ScrollViewOrError(context, state),

                  _buildTitle(),
                  // The Positioned Button
                  _buildAddButton(context),
                ],
              ),
            );
          }
        )
      )

    ));
  }


  Future<void> _reload(BuildContext context) async{
    context.read<MyLocationsCubit>().loadMyLocations();
  }


  //--------------------------------------------------------------------------------------------------------------------------------------------------
  //---------------------------------------------------------------Private Widgets--------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------------------------------


  ///
  /// Determines whether to display the scrollview or the errorWidget
  /// An http error can also occur when deleting, but the view should not be deactivated then,
  /// so if [state.myLocations] is not empty it will be shown anyway
  /// if the [state.status] is [MyLocationStatus.loading] an loading animation is displayed
  ///
  Widget ScrollViewOrError(BuildContext context, MyLocationsState state){
    if(state.status == MyLocationStatus.error && state.myLocations.isEmpty){
      return NetworkErrorWidget(failure: state.failure!);
    }
    return  SingleChildScrollView(
      // this is done so the refresh indicator always works
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 70, bottom: 50),
          child: state.status == MyLocationStatus.loading ?
            SizedBox(child: LoadingEventsAnimation(), height: MediaQuery.of(context).size.height *0.7,) :
            _buildListView(state),
        )
    );
  }

  /// generates Title Positioned Widget
  Positioned _buildTitle() {
    return Positioned(
                  top: 0, left: 0, right: 0,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(color: AppColors.stdButtonBackground),
                      child: Center(child: Text(AppStrings.myLocationsPageHeading, style: AppTextStyles.stdLittleHeading,))),
                );
  }
  /// Generates Bottom Positioned add button
  /// [context] is needed to draw the overlay
  Positioned _buildAddButton(BuildContext context) {
    return Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.accentButtonColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(onPressed: () => MyLocationFormOverlay(context: context), icon: Icon(Icons.add), color: AppColors.textOnAccentColor,)));
  }




  /// Generates Listview of the Locations
  /// [state] is the state of the cubit, it contains the locations
  /// The Listview is not scrollable
  ListView _buildListView(MyLocationsState state) {
    return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: (state).myLocations.length,
                              itemBuilder: (context, index) => MyLocationTile(location: state.myLocations[index],
                                onDelete: context.read<MyLocationsCubit>().deleteMyLocation),
                        separatorBuilder: (context, index)=> const Divider(height: 1, thickness: 1,),);
  }
  
  
}
