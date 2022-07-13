import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/core/geo_functions_cubit.dart';
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
  String? searchSuggestion;

  bool isCooldown = false;

  List<SearchInfo> _searchInfoOtions = <SearchInfo>[];
  bool isLoading = false;
  


  static String _displayStringForOption(SearchInfo option) {

    return option.address.toString();
  }

  @override
  Widget build(BuildContext context) {
    final textEditingControllerLongi = TextEditingController();
    final textEditingControllerLati = TextEditingController();

    addressSuggestion("");
    return BlocListener<EventFormCubit, EventFormState>(
      listener: (context, state) {
        textEditingControllerLongi.text = state.event.longitude!.toString();
        textEditingControllerLati.text = state.event.latitude!.toString();
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                  child: FullWidthPaddingInput(
                labelText: "Longitude",
                controller: textEditingControllerLongi,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890.]'))],
                // onChanged: (value2) => context
                //     .read<EventFormCubit>()
                //     .changeLongitude(double.parse(value2 == "" ? '0' : value2??'0')),
                textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
              )),
              Flexible(
                  child: FullWidthPaddingInput(
                labelText: "Latitude",
                controller: textEditingControllerLati,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890.]'))],
                // onChanged: (value) => context
                //     .read<EventFormCubit>()
                //     .changeLatitude(double.parse(value == "" ? '0' : value??'0')),
                textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
              ))
            ],
          ),
          // FullWidthPaddingInput(
          //   labelText: "Longitude",
          //   controller: textEditingControllerLongi,
          //   inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890.]'))],
          //   // onChanged: (value2) => context
          //   //     .read<EventFormCubit>()
          //   //     .changeLongitude(double.parse(value2 == "" ? '0' : value2??'0')),
          //   textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
          // ),
          // FullWidthPaddingInput(
          //   labelText: "Latitude",
          //   controller: textEditingControllerLati,
          //   inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890.]'))],
          //   // onChanged: (value) => context
          //   //     .read<EventFormCubit>()
          //   //     .changeLatitude(double.parse(value == "" ? '0' : value??'0')),
          //   textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
          // ),
          Autocomplete<SearchInfo>(

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
              this.isCooldown = true;
              Timer(Duration(milliseconds: 1000), () { this.isCooldown = false;});
              _searchInfoOtions = await addressSuggestion(textEditingValue.text);
              if (textEditingValue.text == '') {
                return const Iterable<SearchInfo>.empty();
              }
              setState( (){});
              return (_searchInfoOtions);


            },
            onSelected: (SearchInfo selection) {
              debugPrint('You just selected ${_displayStringForOption(selection)}');
            },

            // optionsViewBuilder: (
            //     BuildContext context,
            //     AutocompleteOnSelected<SearchInfo> onSelected,
            //     Iterable<SearchInfo> options
            //     ) {
            //   return Align(
            //     alignment: Alignment.center,
            //     child: Material(
            //       child: Container(
            //         width: 300,
            //         child: ListView.builder(
            //           padding: EdgeInsets.all(10.0),
            //           itemCount: options.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             final SearchInfo option = options.elementAt(index);
            //
            //             return GestureDetector(
            //               onTap: () {
            //                 onSelected(option);
            //               },
            //               child: ListTile(
            //                 title: Text(option.address.toString(), style: const TextStyle(color: Colors.white)),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ),
            //   );
            // },
          ),

          FullWidthPaddingInput(
            labelText: "Adress",
            onChanged: (value) async {
              List<SearchInfo> suggestions = await addressSuggestion(value);
              this.searchSuggestion = '';
              suggestions.forEach((element) {
                this.searchSuggestion = this.searchSuggestion! + '\n ' + element.address.toString();
              });
              if (suggestions.length != 0) textEditingControllerLati.text = suggestions[0].point?.latitude.toString() ?? '';
              setState(() {});
            },
          ),
          Text(this.searchSuggestion ?? '')
        ],
      ),
    );
  }
}
