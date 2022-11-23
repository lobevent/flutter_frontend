
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/utils/geo/search_completion.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Overlays/my_location_form/cubit/my_locations_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/coordinates_picker_with_adress_autocomplete.dart';
import 'package:flutter_frontend/presentation/pages/preferences/my_locations_page/cubit/my_locations_cubit.dart';

import '../../../../../core/utils/geo/osm_extensions/utilities.dart';


// https://www.kodeco.com/33302203-overlays-in-flutter-getting-started


class MyLocationFormOverlay {
  MyLocationFormOverlay({MyLocation? myLocation, required BuildContext context}) {
    final OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry? overlayEntry;
    // overlayEntry =
    //     OverlayEntry(builder: (context) {
    //       return DismissibleOverlay(overlayEntry: overlayEntry! ,child: test());
    //     });
    overlayEntry =
        OverlayEntry(builder: (context) => DismissibleOverlay(overlayEntry: overlayEntry!, child: MyLocationForm(location: myLocation,),));
    // overlayEntry =
    //     OverlayEntry(builder: (context) => DismissibleOverlay(overlayEntry: overlayEntry!, child: AutocompleteBasicExample(),));
    // overlayEntry =
    //     OverlayEntry(builder: (context) => Dismissible(
    //         onDismissed: (dismissDirection) => overlayEntry?.remove(),
    //         direction: DismissDirection.vertical,
    //         key: Key(''),
    //         child: ColorfulSafeArea(child: AutocompleteBasicExample())
    //     ),);

    overlayState.insert(overlayEntry);
  }
}

//
// class AutocompleteBasicExample extends StatelessWidget {
//   const AutocompleteBasicExample();
//
//   static const List<String> _kOptions = <String>[
//     'aardvark',
//     'bobcat',
//     'chameleon',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Spacer(),
//           Autocomplete<String>(
//             optionsBuilder: (TextEditingValue textEditingValue) {
//               if (textEditingValue.text == '') {
//                 return const Iterable<String>.empty();
//               }
//               return _kOptions.where((String option) {
//                 return option.contains(textEditingValue.text.toLowerCase());
//               });
//             },
//             onSelected: (String selection) {
//               debugPrint('You just selected $selection');
//             },
//           ),
//           Spacer()
//         ],
//       ),
//     );
//   }
// }



// ---------------------------------------------------------------------------------------------------- Just testing ----------------------------------


// class MyLocationFormOverlay {
//   MyLocationFormOverlay({MyLocation? myLocation, required BuildContext context}) {
//     final OverlayState overlayState = Overlay.of(context)!;
//     OverlayEntry? overlayEntry;
//     overlayEntry =
//         OverlayEntry(builder: (context) => Dismissible(
//           key: GlobalKey(),
//         child: AutocompleteBasicExample(),));
//     overlayState.insert(overlayEntry);
//   }
// }



// class test extends StatefulWidget {
//   const test({Key? key}) : super(key: key);
//
//   @override
//   State<test> createState() => _testState();
// }
//
// class _testState extends State<test> {
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   final orgaNameController = TextEditingController();
//   final orgaDescriptionController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//           children: [
//             const SizedBox(height: 20),
//             Text('Create Orgalist', style: Theme.of(context).textTheme.headline3),
//             const SizedBox(height: 20),
//             FullWidthPaddingInput(controller:  orgaNameController, labelText: 'Enter the Organame'),
//             const SizedBox(height: 20),
//             FullWidthPaddingInput(controller:  orgaDescriptionController, labelText: 'Enter the Orgadescription'),
//             StdTextButton(
//                 onPressed: () {
//                 },
//                 child: const Icon(Icons.add, color: AppColors.stdTextColor))
//           ],
//         ));
//   }
// }



//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class MyLocationForm extends StatefulWidget {

  MyLocationForm({Key? key, MyLocation? location}) : super(key: key);

  @override
  State<MyLocationForm> createState() => _MyLocationFormState();
}

class _MyLocationFormState extends State<MyLocationForm> {
  static GlobalKey _formKey = GlobalKey<FormState>();
  final controller_name = TextEditingController();
  final controller_longitude = TextEditingController();
  final controller_latitude = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasicContentContainer(
        child_ren: right(
            BlocProvider(
              create: (context) => MyLocationsFormCubit(),
              child: BlocConsumer<MyLocationsFormCubit, MyLocationsFormState>(
                listenWhen: (p,c) => p.status != c.status,
                listener: (context, state) {
                  if(state.status == MLFStatus.finished){
                    context.router.pop();
                  }
                  controller_name.text = state.location.name.getOrEmptyString();
                  controller_longitude.text = state.location.longitude.toString();
                  controller_latitude.text = state.location.latitude.toString();
                  setState(() {});
                },
                buildWhen: (p, c) => p.runtimeType != c.runtimeType,
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppStrings.addLocation, style: AppTextStyles.stdLittleHeading,),
                        FullWidthPaddingInput(
                          labelText: AppStrings.name,
                          controller: controller_name,
                          hintText: AppStrings.name,
                          onChanged: (value) => _formCubit(context).changeName(value),
                        ),
                        _buildCoordinatesPickerAndAutoCompleteAdress(context),
                        Center(child: StdTextButton(child: Text("Submit"), onPressed: () => _formCubit(context).submit(),),),
                      ],
                    ),
                  );
                }
              ),
            )
        )
    );
  }

  Widget _buildCoordinatesPickerAndAutoCompleteAdress(BuildContext context) {
    return CoordinatesPickerAndAutoCompleteAdress(
                          textEditingControllerLongi: controller_longitude,
                          textEditingControllerLati: controller_latitude,
                          onAdressSelected: _formCubit(context).changeAddress,
                          onLatitudeChanged: _formCubit(context).changeLatitude,
                          onLongitudeChanged: _formCubit(context).changeLongitude);
  }

  MyLocationsFormCubit _formCubit(BuildContext context) {
    return context.read<MyLocationsFormCubit>();
  }
}







//
// class MyLocationForm extends StatefulWidget {
//
//
//   MyLocationForm({Key? key, MyLocation? location}) : super(key: key);
//
//   @override
//   State<MyLocationForm> createState() => _MyLocationFormState();
// }
//
// class _MyLocationFormState extends State<MyLocationForm> {
//
//   // this attribute tells us wheter the address is on cooldown
//   bool isCooldown = false;
//
//   // cooldownduration in Milliseconds
//   static const int cooldownDuration = 1000;
//
//   Timer? timer;
//   List<SearchInfoDetailed> _searchInfoOtions = <SearchInfoDetailed>[];
//
//
//   static String _displayStringForOption(SearchInfoDetailed option) {
//
//     return option.addressDetailed.toString();
//   }
//
//   static GlobalKey _formKey = GlobalKey<FormState>();
//   final controller_name = TextEditingController();
//   final controller_longitude = TextEditingController();
//   final controller_latitude = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BasicContentContainer(
//         child_ren: right(
//             BlocProvider(
//               create: (context) => MyLocationsFormCubit(),
//               child: BlocConsumer<MyLocationsFormCubit, MyLocationsFormState>(
//                   listenWhen: (p,c) => p.runtimeType != c.runtimeType,
//                   listener: (context, state) {
//                     if(state is MyLocationFormAdding){
//                       controller_name.text = state.location.name.getOrEmptyString();
//                       controller_longitude.text = state.location.longitude.toString();
//                       controller_latitude.text = state.location.latitude.toString();
//                       setState(() {});
//                     }
//                   },
//                   buildWhen: (p, c) => p.runtimeType != c.runtimeType,
//                   builder: (context, state) {
//                     return Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           Text(AppStrings.addLocation, style: AppTextStyles.stdLittleHeading,),
//                           FullWidthPaddingInput(
//                             labelText: AppStrings.name,
//                             controller: controller_name,
//                             hintText: AppStrings.name,
//                             onChanged: (value) => _formCubit(context).changeName(value),
//                           ),
//                           ///////---------------------------------------------------------------------------
//                           _buildAdressAutocomplete(context),
//                           ///////---------------------------------------------------------------------------
//                           _buildCoordFields(context),
//                           //_buildCoordinatesPickerAndAutoCompleteAdress(context)
//                         ],
//                       ),
//                     );
//                   }
//               ),
//             )
//         )
//     );
//   }
//   //
//   // CoordinatesPickerAndAutoCompleteAdress _buildCoordinatesPickerAndAutoCompleteAdress(BuildContext context) {
//   //   return CoordinatesPickerAndAutoCompleteAdress(
//   //       textEditingControllerLongi: controller_longitude,
//   //       textEditingControllerLati: controller_latitude,
//   //       onAdressSelected: _formCubit(context).changeAddress,
//   //       onLatitudeChanged: _formCubit(context).changeLatitude,
//   //       onLongitudeChanged: _formCubit(context).changeLongitude);
//   // }
//
//   MyLocationsFormCubit _formCubit(BuildContext context) {
//     return context.read<MyLocationsFormCubit>();
//   }
//
//
//   // ----------------------------------------------------------------------------------------------------------------------------------
//   // ----------------------------------------------------------- WIDGETS --------------------------------------------------------------
//   // ----------------------------------------------------------------------------------------------------------------------------------
//   Autocomplete<SearchInfoDetailed> _buildAdressAutocomplete(BuildContext context) {
//     print("rebuid");
//     return Autocomplete<SearchInfoDetailed>(
//
//       fieldViewBuilder:
//           (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
//         return FullWidthPaddingInput(
//           labelText: AppStrings.address,
//           hintText: AppStrings.address,
//           fieldFocusNode: fieldFocusNode,
//           controller: fieldTextEditingController,
//         );
//       },
//       displayStringForOption: _displayStringForOption,
//       optionsBuilder: (TextEditingValue textEditingValue) async {
//         if(this.isCooldown){
//           return _searchInfoOtions;
//         }
//         // this sets the cooldown
//         //Timer(Duration(milliseconds: cooldownDuration), () async { this.isCooldown = false; });
//         //this.isCooldown = true;
//         //--------
//         // check whether the value is empty
//         if (textEditingValue.text == '') {
//           return const Iterable<SearchInfoDetailed>.empty();
//         }
//         // get suggestion
//         _searchInfoOtions = await addressSuggestionDetailed(textEditingValue.text); // TODO: add copyright notice from OSM and photon
//         //setState( (){});
//         return (_searchInfoOtions);
//       },
//       // set coordinates
//       onSelected: (SearchInfoDetailed selection) {
//         _formCubit(context).changeAddress(selection.addressDetailed.toString());
//          _formCubit(context).changeLatitude(selection.point?.latitude?? 0);
//         _formCubit(context).changeLongitude(selection.point?.longitude?? 0);
//         // TODO: add only jena here!
//         controller_longitude.text = selection.point?.longitude.toString() ?? '';
//         controller_latitude.text = selection.point?.latitude.toString() ?? '';
//       },
//
//       // we can generate an custom view of the options
//     );
//   }
//
//
//
//   ConstrainedBox _buildCoordFields(BuildContext context) {
//     return ConstrainedBox(constraints: BoxConstraints(maxHeight: 56),
//       child:
//
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Flexible(child: CoordinatesPickerInput(
//             textEditingControllerLongi: controller_longitude,
//             labeltext: "longitude",
//             onChanged: (value2) =>
//                 _formCubit(context).changeLongitude(double.parse(value2 == "" ? '0' : value2)),)),
//           Flexible(child: CoordinatesPickerInput(
//             textEditingControllerLongi: controller_latitude,
//             labeltext: "Latitude",
//             onChanged: (value2) => _formCubit(context).changeLatitude(double.parse(value2 == "" ? '0' : value2)),)),
//         ],
//       ),);
//   }
// }

