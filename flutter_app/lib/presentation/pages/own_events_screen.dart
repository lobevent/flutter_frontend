import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:path/path.dart';


class OwnEventsScreenScaffold extends StatelessWidget {

  const OwnEventsScreenScaffold({
    Key? key,
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

      ),);
  }
}


class OwnEventsScreen extends StatefulWidget{
  const OwnEventsScreen({
      Key? key
    }) : super(key: key);
  @override
  _OwnEventsScreenState createState() => _OwnEventsScreenState();
}


class _OwnEventsScreenState extends State<OwnEventsScreen> {



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>OwnEventsCubit(),
      child: BlocConsumer<OwnEventsCubit,OwnEventsState>(
        listener: (context, state){
          print("asdasdasdasdasd");
          state.maybeMap((_) => null,
              error: (value) => FlushbarHelper.createError(message: value.error),
              initial: (_) => context.bloc<OwnEventsCubit>().getOwnEvents() ,
              orElse:  () => print ("asd"));
        },
        builder: (context, state){
          return state.map(
                  (_) => Center(),
              initial: (_){
                    return const Center(child: Text("Rload"));
              },
              loading: (_)=> const Center(child: CircularProgressIndicator(),),
              loaded: (state){
            return ListView.builder(itemBuilder: (context, index) {
              final event = state.events[index];
              if(event.failureOption.isSome()){
                return Container(color: Colors.red, width: 100, height: 100);
              }
              else
                return Container(color: Colors.green, width: 100, height: 100, child: Text(state.events.first.name.getOrCrash()),);
            },
            itemCount: state.events.length
            );

              },
              error: (value)=> Center(child: Text(value.error)));
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