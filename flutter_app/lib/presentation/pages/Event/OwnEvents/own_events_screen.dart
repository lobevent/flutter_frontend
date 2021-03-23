import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/Event/OwnEvents/widgets/own_events_body.dart';
import 'package:flutter_frontend/presentation/pages/core/Widgets/loading_overlay.dart';
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
    );
  }
}

class OwnEventsScreen extends StatefulWidget {
  const OwnEventsScreen({Key? key}) : super(key: key);
  @override
  _OwnEventsScreenState createState() => _OwnEventsScreenState();
}

class _OwnEventsScreenState extends State<OwnEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnEventsCubit(),
      child: BlocConsumer<OwnEventsCubit, OwnEventsState>(
          listener: (context, state) {},
          builder: (context, state) {
            bool isLoading = state.maybeMap((_) => false,
                loading: (_) => true, orElse: () => false);
            return Stack(children: <Widget>[
              OwnEventScreenHolder(),
              LoadingOverlay(isLoading: isLoading)
            ]);
          }),
    );
  }
}

class OwnEventScreenHolder extends StatelessWidget {
  OwnEventScreenHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Own Events"),
        ),
        body: OwnEventsBody());
  }
}
