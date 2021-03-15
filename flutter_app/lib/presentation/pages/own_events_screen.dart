import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/application/own_events_cubit/own_events_state.dart';


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
            if (state is OwnEventsState.initial()) {
              return buildInitialInput();
            } else if (state is OwnEventsState.loading()) {
              return buildLoading();
            } else if (state is OwnEventsState.loaded()) {
              return buildColumnWithData(state.weather);
            } else {
              // (state is WeatherError)
              return buildInitialInput();
            }
          },
        ),
      ),
    );
  }
// more code here...
}