

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

import '../../core/widgets/loading_overlay.dart';

class EventScreenPage extends StatelessWidget {

  final UniqueId eventId;
  const EventScreenPage({Key? key, required this.eventId}): super(key: key);




  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventScreenCubit(eventId),
        child: BlocConsumer<EventScreenCubit, EventScreenState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                EventScreenBody(),
                LoadingOverlay(isLoading: state is LoadInProgress, text: "Saving")
              ],
            );
          },
        ));
  }
}

class EventScreenBody extends StatelessWidget {
  const EventScreenBody({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: BlocBuilder<EventScreenCubit, EventScreenState>(
  //         buildWhen: (p, c) => p.isEditing != c.isEditing,
  //         builder: (context, state) {
  //           return Text(state.isEditing ? 'Edit a Event' : 'Create a Event');
  //         },
  //       ),
  //       actions: <Widget>[
  //         IconButton(
  //           icon: Icon(Icons.check),
  //           onPressed: () {
  //             context.read<EventFormCubit>().saveEvent();
  //           },
  //         )
  //       ],
  //     ),
  //     body: BlocBuilder<EventFormCubit, EventFormState>(
  //         buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
  //         builder: (context, state) {
  //           return Form(
  //             autovalidateMode: state.showErrorMessages? AutovalidateMode.always : AutovalidateMode.disabled,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   const EventNameField(),
  //                   const DescriptionField(),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }
  }

}