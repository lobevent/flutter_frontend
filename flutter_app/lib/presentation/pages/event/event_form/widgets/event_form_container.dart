import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_upload.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/checkbox_area.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/date_picker.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/invite_friends_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/pick_image_widget.dart';
import 'package:image_picker/image_picker.dart';

import 'description_body_widged.dart';
import 'title_widget.dart';

class EventFormContainer extends StatelessWidget {
  final bool showErrorMessages;
  const EventFormContainer({Key? key, this.showErrorMessages = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      // tell the form whether it should show error messages or not
      autovalidateMode: showErrorMessages
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: SingleChildScrollView(
        child: Column(
          children:  [
            ImageUploadPicker(returnFunction: (List<XFile?>? blaa){}),
            /// the input field, where the name is typed
            const EventNameField(), // ATTENTION: the textfieldclasses have to be constant ( research has to be done into this! )

            /// the input filed with the decription
            const DescriptionField(),

            const DatePicker(),

            const CheckBoxArea(),

            const InviteFriendsWidget(),

            const PickImageWidget(),
          ],
        ),
      ),
    );
  }
}
