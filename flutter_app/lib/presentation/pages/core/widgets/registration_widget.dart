
import 'package:flutter/widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

class RegistrationButton extends StatefulWidget {
  final bool clickStatus;

  const RegistrationButton(
      {Key? key,
        required this.clickStatus})
      : super(key: key);

  @override
  _RegistrationButtonState createState() => _RegistrationButtonState(clickStatus);

}

class _RegistrationButtonState extends State<RegistrationButton> {
  bool clickStatus = false;
  _RegistrationButtonState(bool clickStatus) : clickStatus = clickStatus;

  void changeClickStatus() {
    setState(() {
      clickStatus = !clickStatus;
    });
  }

  Widget buildRegistration() {
    return StdTextButton(
        child: Text("Registration"),
        onPressed: () {
          //call backend
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}