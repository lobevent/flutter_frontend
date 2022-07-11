import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/core/geo_functions_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

class CoordsPicker extends StatefulWidget {
  const CoordsPicker({
    Key? key,
  }) : super(key: key);

  @override
  _CoordsPickerState createState() => _CoordsPickerState();
}

class _CoordsPickerState extends State<CoordsPicker> {
  @override
  Widget build(BuildContext context) {
    final textEditingControllerLongi = TextEditingController();
    final textEditingControllerLati = TextEditingController();

    return BlocListener<EventFormCubit, EventFormState>(
      listener: (context, state) {
        textEditingControllerLongi.text = state.event.longitude!.toString();
        textEditingControllerLati.text = state.event.latitude!.toString();
      },
      child: Column(
        children: [
          FullWidthPaddingInput(
            labelText: "Longitude",
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890.]'))],
            onChanged: (value2) => context
                .read<EventFormCubit>()
                .changeLongitude(double.parse(value2 == "" ? '0' : value2??'0')),
            textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
          ),
          FullWidthPaddingInput(
            labelText: "Latitude",
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890.]'))],
            // onChanged: (value) => context
            //     .read<EventFormCubit>()
            //     .changeLatitude(double.parse(value == "" ? '0' : value??'0')),
            textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
          ),
        ],
      ),
    );
  }
}
