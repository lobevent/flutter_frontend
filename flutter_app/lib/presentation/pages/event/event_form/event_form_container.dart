import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/checkbox_area.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/date_picker.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/invite_friends_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/max_persons.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/pick_image_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'widgets/coords_picker.dart';
import 'widgets/description_body_widged.dart';
import 'widgets/event_series/add_to_series.dart';
import 'widgets/title_widget.dart';

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
  bool isCompleted = false;

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
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              setState(() => isCompleted = true);

              ///send data to server
            } else {
              setState(() => currentStep += 1);
            }
          },
          onStepTapped: (step) => setState(() => currentStep = step),
          onStepCancel:
              currentStep == 0 ? null : () => setState(() => currentStep -= 1),
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: [
                if (currentStep < 2)
                  Expanded(
                    child: ElevatedButton(
                      child: Text("NEXT"),
                      onPressed: details.onStepContinue,
                    ),
                  ),
                if (currentStep != 0)
                  Expanded(
                    child: ElevatedButton(
                      child: Text("BACK"),
                      onPressed: details.onStepCancel,
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text(AppStrings.createEventGeneralInfo),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.event != null && widget.event!.image != null)
                  PickImageWidget(
                    loadetFile: widget.event!.image,
                  )
                else
                  const PickImageWidget(),

                /// the input field, where the name is typed
                const EventNameField(), // ATTENTION: the textfieldclasses have to be constant ( research has to be done into this! )

                /// the input filed with the decription
                const DescriptionField(),
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text(AppStrings.createEventTime),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DatePicker(widget.selectedCalenderDate),
                CoordsPicker(),
              ],
            ),
          ),
        ),


        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text(AppStrings.createEventAccess),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CheckBoxArea(),
                const MaxPersons(),
                if (!widget.isEditing) InviteFriendsWidget(),
                if (!widget.isEditing) AddToSeries(),
              ],
            ),
          ),
        ),
      ];
}
