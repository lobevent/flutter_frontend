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

class CoordsPicker extends StatefulWidget {
  const CoordsPicker({
    Key? key,
  }) : super(key: key);

  @override
  _CoordsPickerState createState() => _CoordsPickerState();
}

// ------------------------------ STATE ---------------------------------------------
class _CoordsPickerState extends State<CoordsPicker> {

  // this attribute tells us wheter the address is on cooldown
  bool isCooldown = false;

  // cooldownduration in Milliseconds
  static const int cooldownDuration = 1000;

  Timer? timer;
  List<SearchInfoDetailed> _searchInfoOtions = <SearchInfoDetailed>[];
  final textEditingControllerLongi = TextEditingController();
  final textEditingControllerLati = TextEditingController();


  static String _displayStringForOption(SearchInfoDetailed option) {

    return option.addressDetailed.toString();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<EventFormCubit, EventFormState>(
      listenWhen: (p, c) => p.isLoading != c.isLoading,
      listener: (context, state) {
        textEditingControllerLongi.text = state.event.longitude?.toString()??'';
        textEditingControllerLati.text = state.event.latitude?.toString()??'';
      },
      child: Column(
        children: [

          Autocomplete<SearchInfoDetailed>(

            fieldViewBuilder:
                (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
              return FullWidthPaddingInput(
                fieldFocusNode: fieldFocusNode,
                controller: fieldTextEditingController,
              );
            },
            displayStringForOption: _displayStringForOption,
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if(this.isCooldown){
                return _searchInfoOtions;
              }
              // this sets the cooldown
              Timer(Duration(milliseconds: cooldownDuration), () async { this.isCooldown = false; });
              this.isCooldown = true;
              //--------
              // check whether the value is empty
              if (textEditingValue.text == '') {
                return const Iterable<SearchInfoDetailed>.empty();
              }
              // get suggestion
              _searchInfoOtions = await addressSuggestionDetailed(textEditingValue.text); // TODO: add copyright notice from OSM and photon
              setState( (){});
              return (_searchInfoOtions);
            },
            // set coordinates
            onSelected: (SearchInfoDetailed selection) {
              // TODO: add only jena here!
              textEditingControllerLongi.text = selection.point?.longitude.toString() ?? '';
              textEditingControllerLati.text = selection.point?.latitude.toString() ?? '';
            },

            // we can generate an custom view of the options
          ),
          ConstrainedBox(constraints: BoxConstraints(maxHeight: 56),
            child:

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                    child: FullWidthPaddingInput(
                      // autoValidateMode: AutovalidateMode.onUserInteraction,
                      labelText: "Longitude",
                      controller: textEditingControllerLongi,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890.]'))],
                      onChanged: (value2) => context
                          .read<EventFormCubit>()
                          .changeLongitude(double.parse(value2 == "" ? '0' : value2??'0')),
                      textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
                      validator: (value){
                        if(value == null || value == ''){
                          return 'please provide an longitude';
                        }
                      },
                    )),
                Flexible(
                    child: FullWidthPaddingInput(
                      // autoValidateMode: AutovalidateMode.onUserInteraction,
                      labelText: "Latitude",
                      controller: textEditingControllerLati,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890.]'))],
                      onChanged: (value) => context
                          .read<EventFormCubit>()
                          .changeLatitude(double.parse(value == "" ? '0' : value??'0')),
                      textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
                      validator: (value){
                        if(value == null || value == ''){
                          return 'please provide an latitude';
                        }
                      },
                    ))
              ],
            ),),
        ],
      ),
    );
  }
}
