import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/cubit/event_series_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/cubit/event_series_form_cubit_editingExtension.dart';

class EventSeriesFormMain extends StatelessWidget {

  const EventSeriesFormMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => EventSeriesFormCubit(false),
      child: BlocBuilder<EventSeriesFormCubit, EventSeriesFormState>(builder: (context, state) {
        return BasicContentContainer(
          isLoading: state is ESF_Loading || state is ESF_Saving,
          scrollable: false,
          children: [
            const SizedBox(height: 20),
            Text(AppStrings.createSeries, style: Theme.of(context).textTheme.headline3),
            const SizedBox(height: 20),
            TitleInput(context),
            const SizedBox(height: 20),
            DescriptionInput(context),
            StdTextButton(
                onPressed: () {

                },
                child: const Icon(Icons.add, color: AppColors.stdTextColor))
          ],
        );
      })

    );
  }

  Widget TitleInput(BuildContext context){
    return FullWidthPaddingInput(
      labelText: AppStrings.enterSeriesName,
      maxLength: EventName.maxLength,
      onChanged: (value)=>context.read<EventSeriesFormCubit>().changeTitle(value),
      validator: (_) => context.read<EventSeriesFormCubit>().state.maybeMap(orElse: ()=>null, ready: (ready) => StringValueValidator(ready.series.name.value)),
    );
  }

  Widget DescriptionInput(BuildContext context){
    return FullWidthPaddingInput(
      labelText: AppStrings.enterSeriesDescription,
      maxLength: EventName.maxLength,
      maxLines: 5,
      onChanged: (value)=>context.read<EventSeriesFormCubit>().changeTitle(value),
      validator: (_) => context.read<EventSeriesFormCubit>().state.maybeMap(orElse: ()=>null, ready: (ready) => StringValueValidator(ready.series.name.value)),
    );
  }

  String? StringValueValidator(Either<ValueFailure<String>, String> value){
    return value.fold((failure) => failure.getDisplayStringLocal(), (r) => null);
  }






}
