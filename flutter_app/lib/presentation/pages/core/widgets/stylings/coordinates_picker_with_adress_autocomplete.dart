

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/utils/geo/osm_extensions/utilities.dart';
import 'package:flutter_frontend/presentation/core/utils/geo/search_completion.dart';

import '../styling_widgets.dart';

class CoordinatesPickerAndAutoCompleteAdress extends StatefulWidget {
  final TextEditingController textEditingControllerLongi;
  final TextEditingController textEditingControllerLati;
  final void Function(String selectedAdress) onAdressSelected;
  final void Function(double? latitude) onLatitudeChanged;
  final void Function(double? longitude) onLongitudeChanged;


  const CoordinatesPickerAndAutoCompleteAdress({Key? key, required this.textEditingControllerLongi,required  this.textEditingControllerLati, required this.onAdressSelected, required this.onLatitudeChanged, required this.onLongitudeChanged}) : super(key: key);

  @override
  State<CoordinatesPickerAndAutoCompleteAdress> createState() => _CoordinatesPickerAndAutoCompleteAdressState();
}

//------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------- STATE ---------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
class _CoordinatesPickerAndAutoCompleteAdressState extends State<CoordinatesPickerAndAutoCompleteAdress> {


  // this attribute tells us wheter the address is on cooldown
  bool isCooldown = false;

  // cooldownduration in Milliseconds
  static const int cooldownDuration = 1000;

  Timer? timer;
  List<SearchInfoDetailed> _searchInfoOtions = <SearchInfoDetailed>[];


  static String _displayStringForOption(SearchInfoDetailed option) {

    return option.addressDetailed.toString();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        _buildAdressAutocomplete(),
        _buildCoordFields(),
      ],
    );
  }

  Autocomplete<SearchInfoDetailed> _buildAdressAutocomplete() {
    return Autocomplete<SearchInfoDetailed>(

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
          widget.onAdressSelected(selection.addressDetailed.toString());
          widget.onLatitudeChanged(selection.point?.latitude);
          widget.onLongitudeChanged(selection.point?.longitude);
          // TODO: add only jena here!
          widget.textEditingControllerLongi.text = selection.point?.longitude.toString() ?? '';
          widget.textEditingControllerLati.text = selection.point?.latitude.toString() ?? '';
        },

        // we can generate an custom view of the options
      );
  }

  ConstrainedBox _buildCoordFields() {
    return ConstrainedBox(constraints: BoxConstraints(maxHeight: 56),
        child:

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(child: CoordinatesPickerInput(
              textEditingControllerLongi: widget.textEditingControllerLongi,
              labeltext: "longitude",
              onChanged: (value2) => widget.onLongitudeChanged(double.parse(value2 == "" ? '0' : value2)),)),
            Flexible(child: CoordinatesPickerInput(
              textEditingControllerLongi: widget.textEditingControllerLati,
              labeltext: "Latitude",
              onChanged: (value2) => widget.onLatitudeChanged(double.parse(value2 == "" ? '0' : value2)),)),
          ],
        ),);
  }
}