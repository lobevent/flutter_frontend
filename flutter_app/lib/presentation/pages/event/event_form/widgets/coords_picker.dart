import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/core/geo_functions.dart';
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
                controller: textEditingControllerLongi,
                labelText: "Longitude",
                onChanged: (value) => context
                    .read<EventFormCubit>()
                    .changeLongitude(double.parse(value)),
                textInputType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              FullWidthPaddingInput(
                controller: textEditingControllerLati,
                labelText: "Latitude",
                onChanged: (value) => context
                    .read<EventFormCubit>()
                    .changeLatitude(double.parse(value)),
                textInputType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
    );
  }
}
