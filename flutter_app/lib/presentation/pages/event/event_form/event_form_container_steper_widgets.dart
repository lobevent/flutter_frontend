part of 'event_form_container.dart';


class _StepperControlls extends StatelessWidget {
  final ControlsDetails details;
  final int currentStep;
  final int maxSteps;
  const _StepperControlls({Key? key, required this.details, required this.currentStep, required this.maxSteps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (currentStep != 0)
          Expanded(
            child: ElevatedButton(
              child: Text(AppStrings.stepperButton_back),
              onPressed: details.onStepCancel,
            ),
          ),
        if (currentStep < maxSteps)
          Expanded(
            child: ElevatedButton(
              child: Text(AppStrings.stepperButton_next),
              onPressed: details.onStepContinue,
            ),
          ),
        if (currentStep == maxSteps)
          Expanded(
            child: ElevatedButton(
              child: Text(AppStrings.stepperButton_submit),
              onPressed: context.read<EventFormCubit>().submit,
            ),
          ),
      ],
    );
  }
}











//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ STEPS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



class _GeneralInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Event? event;

  const _GeneralInfoStep({required this.formKey, this.event, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (event != null && event!.image != null)
              PickImageWidget(
                loadetFile: event!.image,
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
    );
  }
}

class _TimeStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final DateTime? selectedCalenderDate;
  const _TimeStep({required this.formKey, this.selectedCalenderDate, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Container(
        height: MediaQuery.of(context).size.height - 500,
          child: DatePicker(selectedCalenderDate),
      ),
    );
  }
}

class _PlaceStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const _PlaceStep({required this.formKey, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Container(
        height: MediaQuery.of(context).size.height - 500,
        child: CoordsPicker(),
      ),
    );
  }
}

class _AccessStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isEditing;
  const _AccessStep({required this.formKey, Key? key, required this.isEditing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        height: MediaQuery.of(context).size.height - 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            const CheckBoxArea(),
            const MaxPersons(),
            if (!isEditing) InviteFriendsWidget(),
            if (!isEditing) AddToSeries(),
          ],
        ),
      ),
    );
  }
}




