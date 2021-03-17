import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:path/path.dart';


class OwnEventsScreenScaffold extends StatelessWidget {

  const OwnEventsScreenScaffold({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Owned Events"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: OwnEventsScreen(),

        /*child: BlocBuilder<OwnEventsCubit, OwnEventsState>(

            builder: (context, state) {
              return state.map((value) => buildInitialInput(),
                  initial: (_) => buildInitialInput(),
                  loading: (_) => buildLoading(),
                  loaded: (value) => null,
                  //buildColumnWithData(value.events),
                  error: null);
            }
        ),

         */
      ),);
  }
}

/*
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

 */
class OwnEventsScreen extends StatelessWidget {

  const OwnEventsScreen({
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>OwnEventsCubit(),
      child: BlocConsumer<OwnEventsCubit,OwnEventsState>(
        listener: (context, state){
          state.maybeMap((error) => null,
              orElse: null);

        },
        builder: (context, state){
          return state.map((
              _) => Center(),
              initial: (_)=> const Center(child: Text('Rload')),
              loading: (_)=> const Center(child: CircularProgressIndicator(),),
              loaded: (state){
            return ListView.builder(itemBuilder: (context, index) {
              final event = state.events[index];
              if(event.failureOption.isSome()){
                return Container(color: Colors.red, width: 100, height: 100);
              }
              else
                return Container(color: Colors.green, width: 100, height: 100);
            },
            itemCount: state.events.length
            );

              },
              error: (value)=> const Center());
          return Stack(
            children: <Widget>[
              const OwnEventsScreenScaffold(),
            ],
          );
        }
      ),

    );
  }
}