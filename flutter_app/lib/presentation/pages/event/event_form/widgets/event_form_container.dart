import 'package:flutter/cupertino.dart';

import 'description_body_widged.dart';
import 'title_widget.dart';

class EventFormContainer extends StatelessWidget{
  final bool showErrorMessages;
  const EventFormContainer({Key? key, this.showErrorMessages = true}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Form( // tell the form whether it should show error messages or not
      autovalidateMode: showErrorMessages
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: SingleChildScrollView(
        child: Column(
          children: const [
            /// the input field, where the name is typed
            EventNameField(),

            /// the input filed with the decription
            DescriptionField(),
          ],
        ),
      ),
    );
  }

}