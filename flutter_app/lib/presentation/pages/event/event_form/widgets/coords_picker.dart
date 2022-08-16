import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/core/geo_functions_cubit.dart';
import 'package:flutter_frontend/presentation/core/utils/geo/osm_extensions/utilities.dart';
import 'package:flutter_frontend/presentation/core/utils/geo/search_completion.dart';
import 'package:flutter_frontend/presentation/core/utils/validators/distanceCoordinatesValidator.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../../core/widgets/stylings/coordinates_picker_with_adress_autocomplete.dart';

class CoordsPicker extends StatefulWidget {
  const CoordsPicker({
    Key? key,
  }) : super(key: key);

  @override
  _CoordsPickerState createState() => _CoordsPickerState();
}

// ------------------------------ STATE ---------------------------------------------
class _CoordsPickerState extends State<CoordsPicker> {

  final textEditingControllerLongi = TextEditingController();
  final textEditingControllerLati = TextEditingController();



  @override
  Widget build(BuildContext context) {

    return BlocListener<EventFormCubit, EventFormState>(
      listenWhen: (p, c) => p.isLoading != c.isLoading,
      listener: (context, state) {
        textEditingControllerLongi.text = state.event.longitude?.toString()??'';
        textEditingControllerLati.text = state.event.latitude?.toString()??'';
      },
      child: _buildAutocompleteAndCoords(context),
    );
  }

  Widget _buildAutocompleteAndCoords(BuildContext context)  {
    return CoordinatesPickerAndAutoCompleteAdress(
      textEditingControllerLongi: textEditingControllerLongi,
      textEditingControllerLati: textEditingControllerLati,
      onAdressSelected: context.read<EventFormCubit>().changeAddress,
      onLatitudeChanged: context.read<EventFormCubit>().changeLatitude,
      onLongitudeChanged: context.read<EventFormCubit>().changeLongitude,);

  }
}





