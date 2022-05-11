import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/cubit/event_series_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/cubit/event_series_form_cubit_editingExtension.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventSeriesFormMain extends StatefulWidget {


  const EventSeriesFormMain({Key? key}) : super(key: key);

  @override
  State<EventSeriesFormMain> createState() => _EventSeriesFormMainState();
}

class _EventSeriesFormMainState extends State<EventSeriesFormMain> {
  final TextEditingController desc_controller = TextEditingController();

  final TextEditingController title_controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventSeriesFormCubit(false),
        child: BlocConsumer<EventSeriesFormCubit, EventSeriesFormState>(
          listener: (context, state) {
            if(state is ESF_SavedReady){
              // display snackbar
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("+++++ Successfully created ++++++")));
              // pop until feed (home)
              context.router.popUntil(
                (route) => route.settings.name == FeedScreenRoute.name,
              );
            }
          },
            // this is the view!
          builder: (context, state) {
            return BasicContentContainer(
              isLoading: state is ESF_Loading || state is ESF_Saving,
              scrollable: true,
              children: [
                const SizedBox(height: 20),
                Text(AppStrings.createSeries, style: Theme.of(context).textTheme.headline3),
                const SizedBox(height: 20),
                // every input has to be inside the form
                Form(
                      key: _formKey,
                      child: Column(children: [
                        // title field
                        TitleInput(context),
                        const SizedBox(height: 20),
                        // description field
                        DescriptionInput(context),
                  ],)
                ),
                SubmitButton(context)
            ],
        );
      })

    );
  }
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++      WIDGETS      +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  ///
  /// The submission button, which also calls the validation function!
  ///
  Widget SubmitButton(BuildContext context){
    return StdTextButton(
        onPressed: () {
          // only submit if the form is valid!
          if (_formKey.currentState!.validate()) {
            context.read<EventSeriesFormCubit>().saveSeries();
          }
        },
        child: const Icon(Icons.add, color: AppColors.stdTextColor));
  }


  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------- INPUTS ----------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  Widget TitleInput(BuildContext context){
    return FullWidthPaddingInput(
      labelText: AppStrings.enterSeriesName,
      controller: title_controller,
      maxLength: EventName.maxLength,
      onChanged: (value)=>context.read<EventSeriesFormCubit>().changeTitle(value),
      validator: (_) => context.read<EventSeriesFormCubit>().state.maybeMap(orElse: ()=>null, ready: (ready) => StringValueValidator(ready.series.name.value)),
    );
  }

  Widget DescriptionInput(BuildContext context){
    return FullWidthPaddingInput(
      labelText: AppStrings.enterSeriesDescription,
      controller: desc_controller,
      maxLength: EventDescription.maxLength,
      maxLines: 5,
      onChanged: (value)=>context.read<EventSeriesFormCubit>().changeDescription(value),
      validator: (_) => context.read<EventSeriesFormCubit>().state.maybeMap(orElse: ()=>null, ready: (ready) => StringValueValidator(ready.series.description.value)),
    );
  }


  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ AUXILIARY FUNCTIONS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  String? StringValueValidator(dartz.Either<ValueFailure<String>, String> value){
    return value.fold((failure) => failure.getDisplayStringLocal(), (r) => null);
  }
}
