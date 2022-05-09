import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/cubit/event_series_form_cubit.dart';

class EventSeriesFormMain extends StatelessWidget {

  const EventSeriesFormMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => EventSeriesFormCubit(false),
      child: BasicContentContainer(
        scrollable: false,
        children: [
          LoadingOverlay(
            isLoading: false,
            child: Container(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text('Create Orgalist', style: Theme.of(context).textTheme.headline3),
                  const SizedBox(height: 20),
                  FullWidthPaddingInput(/*controller:  orgaNameController,*/ labelText: 'Enter the Organame'),
                  const SizedBox(height: 20),
                  FullWidthPaddingInput(/*controller:  orgaDescriptionController, */labelText: 'Enter the Orgadescription'),
                  StdTextButton(
                      onPressed: () {

                      },
                      child: const Icon(Icons.add, color: AppColors.stdTextColor))
                ],
              ),
            ),
        )],
      ),
    );
  }
}
