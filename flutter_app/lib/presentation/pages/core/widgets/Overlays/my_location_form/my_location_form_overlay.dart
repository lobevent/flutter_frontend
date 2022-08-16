import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Overlays/my_location_form/cubit/my_locations_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

class MyLocationFormOverlay {
  MyLocationFormOverlay({MyLocation? myLocation, required BuildContext context}) {
    final OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry? overlayEntry;
    overlayEntry =
        OverlayEntry(builder: (context) => DismissibleOverlay(overlayEntry: overlayEntry!, child: _MyLocationForm(location: myLocation,),));
    overlayState.insert(overlayEntry);
  }
}

class _MyLocationForm extends StatelessWidget {
  _MyLocationForm({Key? key, MyLocation? location}) : super(key: key);

  final controller_name = TextEditingController();
  final controller_longitude = TextEditingController();
  final controller_latitude = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BasicContentContainer(
        child_ren: right(
            BlocProvider(
              create: (context) => MyLocationsFormCubit(),
              child: BlocBuilder<MyLocationsFormCubit, MyLocationsFormState>(
                builder: (context, state) {
                  return Container(
                    child: Form(
                      child: Column(
                        children: [
                          Text(AppStrings.addLocation, style: AppTextStyles.stdLittleHeading,),
                          FullWidthPaddingInput(
                            labelText: AppStrings.name,
                            controller: controller_name,
                            hintText: AppStrings.name,
                            onChanged: (value) => _formCubit(context).changeName(value),
                          ),
                          FullWidthPaddingInput(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
        )
    );
  }

  MyLocationsFormCubit _formCubit(BuildContext context) {
    return context.read<MyLocationsFormCubit>();
  }
}
