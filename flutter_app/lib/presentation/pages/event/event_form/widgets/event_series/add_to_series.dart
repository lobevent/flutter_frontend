import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

import '../../../../../../domain/event/event_series.dart';

class AddToSeries extends StatefulWidget {
  const AddToSeries({Key? key}) : super(key: key);

  @override
  State<AddToSeries> createState() => _AddToSeriesState();
}

class _AddToSeriesState extends State<AddToSeries> {
  List<EventSeries> series = [];
  EventSeries? selected = null;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventFormCubit, EventFormState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state.seriesStatus == SeriesStatus.ready) {
            setState(() {
              series = state.series;
              isLoading = false;
            });
          }
          if(state.seriesStatus == SeriesStatus.error){
            throw UnimplementedError(); // TODO: implement ERRORSNACKBAR ASAP
          }
        },
        child: Column(children: [
          DropdownButton<EventSeries>(
            value: selected,
            //icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            underline: Container(
              height: 2,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onChanged: (EventSeries? newValue) {
              context.read<EventFormCubit>().setEventSeries(newValue);
              setState(() {
                selected = newValue!;
              });
            },
            items:
                series.map<DropdownMenuItem<EventSeries>>((EventSeries value) {
              return DropdownMenuItem<EventSeries>(
                value: value,
                child: Text(value.name.getOrCrash()),
              );
            }).toList(),
          ),
          if (isLoading) LinearProgressIndicator()
        ]));
  }
}
