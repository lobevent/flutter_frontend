import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/own_events_cubit/own_events_state.dart' as oes;
import 'package:flutter_frontend/application/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';


class OwnEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Owned Events"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocBuilder<OwnEventsCubit, OwnEventsState>(

            builder: (context, state) {
              return state.map((value) => buildInitialInput(),
                  initial: (_) => buildInitialInput(),
                  loading: (_) => buildLoading(),
                  loaded: (List<Event> ownEventsList) => buildColumnWithData(List<Event> ownEventsList),
                  error: null);
            }
        ),
      ),);
  }


// more code here...
  Widget buildInitialInput() {
    return Center(
      child: Text('Nothing here'),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildColumnWithData(List<Event> OwnEventList) {
    final children = <Widget>[];
    for (var i = 0; i < OwnEventList.length; i++) {
      children.add(new Text(OwnEventList[i].name.getOrCrash()));
    }
    return new Center(
      child: new Column(
      children: children,
    ),
    );
  }
}