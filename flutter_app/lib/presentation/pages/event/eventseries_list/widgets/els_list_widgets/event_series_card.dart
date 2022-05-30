import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/loading_button.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/event/eventseries_list/cubit/event_series_list_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventSeriesCard extends StatefulWidget {
  final EventSeries series;
  const EventSeriesCard({Key? key, required this.series, }) : super(key: key);

  @override
  State<EventSeriesCard> createState() => _EventSeriesCardState();
}

class _EventSeriesCardState extends State<EventSeriesCard> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventSeriesListCubit, EventSeriesListState>(builder: (context, state) {
      return Card(child: ListTile(
        // center here so the text is centered
        title: Center(child: Text(widget.series.name.getOrCrash())),
        // only show the leading button when we are not deleting
        leading: !deleting ? IconButton(icon: Icon(Icons.preview), onPressed: (){
          context.router.push(EventSeriesScreenPageRoute(seriesId: widget.series.id));}, ): null,
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // show the loading animation when we delete
              if(deleting) SpinKitRotatingCircle(color: AppColors.primaryColor, size: 20,),
              // dont show this if we are deleting
              if(!deleting) IconButton(icon: Icon(Icons.edit), onPressed: (){context.router.push(EventSeriesFormMainRoute());},),
              if(!deleting) IconButton(onPressed: (){deleteSeries(context, widget.series);}, icon: Icon(Icons.delete))]
        ),

      ));
    });
  }


  /// deletes series! asks for confirmation and if the events in the series should be deleted
  /// also sets the deleting flag
  void deleteSeries(BuildContext context, EventSeries series) async{
    bool answer = await GenDialog.genericDialog(context, "Confirm delete", "Are you sure you want to delete" + series.name.getOrCrash());
    if(answer){
      bool withEvents = await GenDialog.genericDialog(context, "With Events?", "Should the series be deleted with Events?");
      // set the deleting flag
      setState(() {deleting = true;});
      // make the cubit call and unset the deleting flag
      context.read<EventSeriesListCubit>().deleteSeries(series, withEvents).then((value) => setState((){deleting = false;}));
    }
  }
}
