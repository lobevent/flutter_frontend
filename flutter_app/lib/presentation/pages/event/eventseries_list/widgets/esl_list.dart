import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/event/eventseries_list/cubit/event_series_list_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/eventseries_list/widgets/els_list_widgets/event_series_card.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventSeriesList extends StatefulWidget {
  final bool own;
  const EventSeriesList({Key? key, required this.own}) : super(key: key);

  @override
  State<EventSeriesList> createState() => _EventSeriesListState();
}

class _EventSeriesListState extends State<EventSeriesList> {
  var series = <EventSeries>[];


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<EventSeriesListCubit, EventSeriesListState>(
        listener: (previuos, current) {
          current.maybeMap(
              orElse: (){},
              ready: (readyState) => setState((){series = widget.own ? readyState.seriesList.own : readyState.seriesList.subscribed;}));;
        },
        builder: (context, state)
        {
          state.maybeMap(orElse: (){}, ready: (readyState) => series = widget.own ? readyState.seriesList.own : readyState.seriesList.subscribed);
            return  ListView.builder(
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: series.length,
                  itemBuilder: (context, i) {
                    return EventSeriesCard(series: series[i]);
                  });
        });
  }


}
