import 'dart:async';

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/core/geo_functions_cubit.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/core/utils/geo/osm_extensions/utilities.dart';
import 'package:flutter_frontend/presentation/core/utils/geo/search_completion.dart';
import 'package:flutter_frontend/presentation/core/utils/validators/distanceCoordinatesValidator.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Overlays/my_location_form/my_location_form_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/circle_beating.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/coords_picker/cubit/coords_picker_cubit.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../../core/widgets/stylings/coordinates_picker_with_adress_autocomplete.dart';

class CoordsPicker extends StatefulWidget {
  const CoordsPicker({
    Key? key,
  }) : super(key: key);

  @override
  _CoordsPickerState createState() => _CoordsPickerState();
}

// ------------------------------ STATE ---------------------------------------------
class _CoordsPickerState extends State<CoordsPicker> {
  bool loadingLocations = true;
  List<MyLocation> locations = [];
  Option<NetWorkFailure> failed = none();
  MyLocation? selectedItem;

  final GlobalKey<FormFieldState> _selectionKey = GlobalKey<FormFieldState>();
  final textEditingControllerLongi = TextEditingController();
  final textEditingControllerLati = TextEditingController();
  TextEditingValue? initialTextValueAddress;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CoordsPickerCubit(),
      child: BlocBuilder<CoordsPickerCubit, CoordsPickerState>(
        builder: (context, state) {
          return MultiBlocListener(
            listeners: [
              BlocListener<EventFormCubit, EventFormState>(
                  listenWhen: (p, c) => p.status != c.status,
                  listener: (context, state) {
                    textEditingControllerLongi.text = state.event.longitude?.toString() ?? '';
                    textEditingControllerLati.text = state.event.latitude?.toString() ?? '';
                    initialTextValueAddress = TextEditingValue(text: state.event.address?.toString() ?? ''); // TODO: Initial Value is not showing
                    if (state.event.myLocation != null) {
                      selectedItem = state.event.myLocation;
                      setState(() {});
                    }
                  }),
              BlocListener<CoordsPickerCubit, CoordsPickerState>(
                  listenWhen: (p, c) => p.status != c.status,
                  listener: (context, state) {
                    switch (state.status) {
                      case CoordsStatus.loading:this.loadingLocations = true;break;
                      case CoordsStatus.saving:this.loadingLocations = true;break;
                      case CoordsStatus.reloading:this.loadingLocations = true;break;
                      case CoordsStatus.ready:
                        {
                          this.loadingLocations = false;
                          locations = state.locations;
                          if (selectedItem != null) {
                            selectedItem = locations.firstWhere((element) => element.id?.value == selectedItem!.id?.value);
                            setState(() {});
                          }
                          break;
                        }
                      case CoordsStatus.error:this.failed = Some(state.failure!);break;
                    }
                  }),
            ],
            child: _buildAutocompleteAndCoords(context),
          );
        },
      ),
    );
  }

  /// the mainChild
  /// this is the real BuildMethod above is only Bloc stuff
  /// if an location is selected, the form for the  Coordinates and the Location dissapears
  ///
  Widget _buildAutocompleteAndCoords(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 80, child: _buildDropdownButton(context)),
        if (selectedItem != null) _displaySelectedLocation(),
        Visibility(
          child: Text("Or provide coordinates by searching for address!", style: TextStyle(color: AppColors.accentColor)),
          visible: selectedItem == null,
        ),
        Visibility(
          visible: selectedItem == null,
          child: CoordinatesPickerAndAutoCompleteAdress(
            isPadded: false,
            initialValue: initialTextValueAddress,
            textEditingControllerLongi: textEditingControllerLongi,
            textEditingControllerLati: textEditingControllerLati,
            onAdressSelected: context.read<EventFormCubit>().changeAddress,
            onLatitudeChanged: context.read<EventFormCubit>().changeLatitude,
            onLongitudeChanged: context.read<EventFormCubit>().changeLongitude,
          ),
        ),
      ],
    );
  }

  ///
  /// Selection for saved Locations
  /// Generates an [DropdownButtonFormField]
  ///
  Widget _buildDropdownButton(BuildContext context) {
    if (loadingLocations) {
      return CircleBeating(color: AppColors.textOnAccentColor, size: 20);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: DropdownButtonFormField(
              value: selectedItem,
              key: _selectionKey,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              selectedItemBuilder: (_) => locations.map((e) => _selectedItem(e)).toList(),
              decoration: const InputDecoration(border: OutlineInputBorder(), label: Text("Select saved Location")),
              isExpanded: true,
              items: locations.map((e) => _dropDownItem(e)).toList(),
              onChanged: (MyLocation? location) {
                _data_setSelected(location!);
              }),
        ),
        // button to reset the selection
        IconButton(onPressed: () {_data_resetSelection();}, icon: Icon(Icons.restart_alt), tooltip: AppStrings.resetSelection,),
        // opens dialog with location save
        IconButton(
            tooltip: AppStrings.addLocation,
            onPressed: () => showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 400), child: MyLocationForm()),
                    )).then((value) => context.read<CoordsPickerCubit>().reloadLocations()),
            icon: Icon(Icons.add)),
      ],
    );
  }

  ///
  /// generate DropDownMenuItem, we use an ListTile here for displaying the content
  ///
  DropdownMenuItem<MyLocation> _dropDownItem(MyLocation location) {
    return DropdownMenuItem<MyLocation>(
        value: location,
        child: Center(
          child: ListTile(
            title: Text(location.name.getOrEmptyString()),
            subtitle: Text(location.address.getOrEmptyString()),
          ),
        ));
  }

  ///
  /// generates View for the selected item, because displaying a ListTile in Selection is a pain in the ass
  ///
  DropdownMenuItem<MyLocation> _selectedItem(MyLocation location) {
    return DropdownMenuItem<MyLocation>(
      value: location,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(location.name.getOrEmptyString()),
        ],
      ),
    );
  }

  ///
  /// A Widget for displaying the currently selected Location
  /// When typing on the coordinates, it opens google maps with the coordinates in it
  ///
  Widget _displaySelectedLocation() {
    return ListTile(
        title: Center(child: Text(selectedItem!.address.getOrEmptyString())),

        minVerticalPadding: 20,
        visualDensity: VisualDensity.comfortable,
        subtitle: Padding(
          padding: EdgeInsets.only(top: 20),
          child: InkWell(
            splashColor: AppColors.primaryColor,
            onTap: () {
              if (selectedItem!.latitude != null && selectedItem!.longitude != null) {
                MapsLauncher.launchCoordinates(selectedItem!.latitude, selectedItem!.longitude);
              }
            },
            child: Column(
              children: [Text("lat: " + selectedItem!.latitude.toString()), Text("long: " + selectedItem!.longitude.toString())],
            ),
          ),
        ));
  }

  ///
  /// if an Location is Selected, it is resetted
  ///
  void _data_resetSelection() {
    _selectionKey.currentState?.reset();
    selectedItem = null;
    if (_selectionKey.currentContext != null) {
      FocusScope.of(_selectionKey.currentContext!).unfocus();
    }
    setState(() {});
  }

  /// performs all the necessary operation when an Location is selected
  /// of course it gets an [MyLocation] to perform the operation
  void _data_setSelected(MyLocation location) {
    selectedItem = location;
    context.read<EventFormCubit>().changeAddress(location.address.getOrEmptyString());
    context.read<EventFormCubit>().changeLatitude(location.latitude);
    context.read<EventFormCubit>().changeLongitude(location.longitude);
    context.read<EventFormCubit>().changeMyLocation(location);
    setState(() {});
  }
}
