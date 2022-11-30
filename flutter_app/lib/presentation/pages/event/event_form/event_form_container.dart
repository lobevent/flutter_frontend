import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/event_form.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/checkbox_area.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/date_picker.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/invite_friends_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/max_persons.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/pick_image_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets/coords_picker/coords_picker.dart';
import 'widgets/description_body_widged.dart';
import 'widgets/event_series/add_to_series.dart';
import 'widgets/title_widget.dart';
part 'event_form_container_steper_widgets.dart';

class EventFormContainer extends StatefulWidget {
  final bool showErrorMessages;
  final bool isEditing;
  final Event? event;
  final DateTime? selectedCalenderDate;
  const EventFormContainer(
      {Key? key,
      this.showErrorMessages = true,
      required this.isEditing,
      this.event,
      this.selectedCalenderDate})
      : super(key: key);

  @override
  State<EventFormContainer> createState() => _EventFormContainerState();
}

class _EventFormContainerState extends State<EventFormContainer> {
  int currentStep = 0;
  int maxStep = 0;
  bool isCompleted = false;

  final List<GlobalKey<FormState>> formKeys = [
    /// General Info FormField
    GlobalKey<FormState>(),
    /// Time
    GlobalKey<FormState>(),
    /// Place
    GlobalKey<FormState>(),
    /// Access
    GlobalKey<FormState>(),];

  @override
  Widget build(BuildContext context) {
    return Form(
      // tell the form whether it should show error messages or not
      autovalidateMode: widget.showErrorMessages
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Expanded(
        //fit: FlexFit.loose,
        child: Stepper(
          type: StepperType.vertical,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () => _stepContinue(),
          onStepTapped: (step) => _stepTap(step),
          onStepCancel: currentStep == 0 ? null : () => setState(() => currentStep -= 1),
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            maxStep = max(maxStep, currentStep);
            return _StepperControlls(details: details, currentStep: currentStep, maxSteps: getSteps().length - 1,);
          }
        ),
      ),
    );
  }

  /// this getter generates a list of the implemented steps
  List<Step> getSteps() => [
        Step(
          state: _calculateStepState(0),
          isActive: currentStep == 0,
          title: Text(AppStrings.createEventGeneralInfo),
          content: _GeneralInfoStep(formKey: formKeys[0],event: widget.event)
        ),
        Step(
          state: _calculateStepState(1),
          isActive: currentStep == 1,
          title: Text(AppStrings.createEventTime),
          content: _TimeStep(formKey: formKeys[1],selectedCalenderDate: widget.selectedCalenderDate,),
        ),

        Step(
          state: _calculateStepState(2),
          isActive: currentStep == 2,
          title: Text(AppStrings.createEventPlace),
          content: _PlaceStep(formKey: formKeys[2],),
        ),


        Step(
          state: _calculateStepState(3),
          isActive: currentStep >= 3,
          title: Text(AppStrings.createEventAccess),
          label: Text(AppStrings.createEventAccess),
          content: _AccessStep(formKey: formKeys[3],isEditing: widget.isEditing),
        ),
      ];



  /// this function should be called when the step should be incremented
  /// it blocks progression if the validation fails
  void _stepContinue(){
    //formKeys[currentStep].currentState?.validate();
    if(!(formKeys[currentStep].currentState?.validate()??false)){
     return;
    }

    final isLastStep = currentStep + 1  == getSteps().length - 1;
    if (isLastStep) {
      bool isValid = true;
      formKeys.forEach((element) {
        isValid &= element.currentState?.validate()??false;
      });
      if(isValid){
        setState(() => isCompleted = true);
        EventFormPage.of(context)?.canSubmit = true;
      }
      ///send data to server
    }
      setState(() => currentStep += 1);
  }

  /// this method should be called when an step is tapped
  /// the step change is blocked if validation fails
  void _stepTap(int step){
    if(!(formKeys[currentStep].currentState?.validate()??false) && maxStep < step){
      return;
    }
    setState(() => currentStep = step);
  }


  /// here we want to generate the step state
  /// the step state decides how the step is displayed e.g. whether an Error is shown
  /// or the step is displayed completed
  StepState _calculateStepState(int stepIndex){
    if(currentStep > stepIndex || maxStep > stepIndex){
      if(formKeys[stepIndex].currentState?.validate()??false){
        return StepState.complete;
      }else{
        return StepState.error;
      }
    } else {
      if(currentStep == stepIndex ){
        return StepState.editing;
      }else {
        // if we have already stepped at least to the stepindex, we should check whether we left it broken or not
        if(currentStep < stepIndex && maxStep >= stepIndex){
          if(formKeys[stepIndex].currentState?.validate()??false){
            return StepState.complete;
          }else{
            return StepState.error;
          }
        }
        return StepState.indexed;
      }
    }
  }
}
