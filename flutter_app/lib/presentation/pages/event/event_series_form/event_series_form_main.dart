import'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/cubit/event_series_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/cubit/event_series_form_cubit_editingExtension.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventSeriesFormMain extends StatefulWidget {

  final EventSeries? series;
  const EventSeriesFormMain({Key? key, this.series}) : super(key: key);

  @override
  State<EventSeriesFormMain> createState() => _EventSeriesFormMainState();
}

class _EventSeriesFormMainState extends State<EventSeriesFormMain> {
  final TextEditingController desc_controller = TextEditingController();

  final TextEditingController title_controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventSeriesFormCubit(widget.series),
        child: BlocConsumer<EventSeriesFormCubit, EventSeriesFormState>(
          listener: (context, state) {
            // somehow this is not called during builder
            // state.maybeMap(orElse: (){}, ready: (readyState) {
            //   title_controller.text = readyState.series.name.getOrEmptyString();
            //   desc_controller.text = readyState.series.description.getOrEmptyString();
            //   setState(() {});
            // });
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
              isLoading: false,//state is ESF_Loading || state is ESF_Saving,
              scrollable: true,
              child_ren: dartz.left([
                const SizedBox(height: 20),
                Text(AppStrings.createSeries, style: Theme.of(context).textTheme.headline3),
                const SizedBox(height: 20),
                // every input has to be inside the form
                MainForm(context),
                SubmitButton(context)
            ]),
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

  Widget MainForm(BuildContext context){
    return BlocListener<EventSeriesFormCubit, EventSeriesFormState>(
      listenWhen: (p, c) => (p is ESF_Ready) != (c is ESF_Ready),
      listener: (context, state) {
        state.maybeMap(orElse: (){}, ready: (readyState) {
          title_controller.text = readyState.series.name.getOrEmptyString();
          desc_controller.text = readyState.series.description.getOrEmptyString();
        });
      },
      child: Form(
          key: _formKey,
          child: Column(children: [
            // title field
            TitleInput(context),
            const SizedBox(height: 20),
            // description field
            DescriptionInput(context),
          ],)
      ),
    );
  }

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
