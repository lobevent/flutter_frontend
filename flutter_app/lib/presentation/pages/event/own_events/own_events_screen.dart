import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/Event/own_events/widgets/own_events_body.dart';
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
          listener: (context, state) {
        print("asdasdasdasdasd");
        state.maybeMap((_) => null,
            //error: (value) => FlushbarHelper.createError(message: value.error),
            initial: (_) =>
                context.read().bloc<OwnEventsCubit>().getOwnEvents(),
            orElse: () => print("asd"));
      }, builder: (context, state) {
        return Scaffold(
            body: OwnEventsBody());
        // return Stack(
        //   children: <Widget>[
        //     const OwnEventsScreenScaffold(),
        //   ],
        // );
      }),
    );
  }
}
