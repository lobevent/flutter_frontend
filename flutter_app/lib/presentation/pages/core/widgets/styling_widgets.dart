import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
//TODO: Move this all to seperate files


const double paddingLeftConst = 30;
const double paddingTopConst = 0;
const double paddingRightConst = 30;
const double paddingBottomConst = 0;
const stdPadding = EdgeInsets.fromLTRB(
    paddingLeftConst, paddingTopConst, paddingRightConst, paddingBottomConst);

/// the content Container should contain no logic, but should only call the
/// content widgets
class BasicContentContainer extends StatelessWidget {
  final List<Widget> children;
  final bool scrollable;
  final ScrollController? controller;
  // https://stackoverflow.com/questions/54114221/flutter-fixed-button-in-customscrollview
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  const BasicContentContainer(
      {Key? key,
        required this.children,
        this.bottomNavigationBar,
        this.controller,
        this.appBar,
        this.scrollable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!scrollable) {
      return Scaffold(
        appBar: appBar,
        body: ColorfulSafeArea(
          color: Colors.yellow,
          child: Column(
            children: children,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      );
    }
    return Scaffold(
      appBar: appBar,
      body: ColorfulSafeArea(
        color: Colors.yellow,
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: children,
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

/// Widget used for making padding with a row, so the children start on the
/// correct side and is padded from the side
class PaddingRowWidget extends StatelessWidget {
  final List<Widget> children;

  /// the padding value on the left side
  final double paddinfLeft;

  /// the padding value on the top
  final double paddingTop;

  /// the padding value on the right side
  final double paddingRight;

  /// the padding value on the bottom
  final double paddingBottom;

  const PaddingRowWidget(
      {Key? key,
      required this.children,
      this.paddinfLeft = paddingLeftConst,
      this.paddingTop = paddingTopConst,
      this.paddingRight = paddingRightConst,
      this.paddingBottom = paddingBottomConst})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          paddinfLeft, paddingTop, paddingRight, paddingBottom),
      child: Row(children: children),
    );
  }
}

/// Widget used for making padding with an conatiner, so the child are padded from the side
class PaddingContainer extends StatelessWidget {
  final Widget child;

  /// the padding value on the left side
  final double paddinfLeft;

  /// the padding value on the top
  final double paddingTop;

  /// the padding value on the right side
  final double paddingRight;

  /// the padding value on the bottom
  final double paddingBottom;

  const PaddingContainer(
      {Key? key,
      required this.child,
      this.paddinfLeft = paddingLeftConst,
      this.paddingTop = paddingTopConst,
      this.paddingRight = paddingRightConst,
      this.paddingBottom = paddingBottomConst})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          paddinfLeft, paddingTop, paddingRight, paddingBottom),
      child: child,
    );
  }
}

/// class primary for texts, that could overflow
class OverflowSafeString extends StatelessWidget {
  final Widget child;
  const OverflowSafeString({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        // overflow is alowed, so no overflowerror arises
        child: SizedOverflowBox(
      //the alignment of the content should be on the left side and
      // vertical it should be centered
      alignment: Alignment.centerLeft,
      size: Size(MediaQuery.of(context).size.width * 0.2, 30),
      child: child,
    ));
  }
}

class StdTextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool disabled;
  const StdTextButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            color: disabled ? Color(0x2A000000) : Color(0x2ABBBBBB),
            /*   border:Border.all(width: 2.0,
                  color:  Color(0x6BBBBBBB)),*/
            borderRadius: BorderRadius.circular(10)),
        child: TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Color(0xFFCECECE))),
            onPressed: () =>
                onPressed == null || disabled ? null : onPressed!(),
            child: child));
  }
}

/// A simple Button for displaying text, and an icon
class TextWithIconButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool disabled;
  const TextWithIconButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.icon,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StdTextButton(
      disabled: disabled,
      // the call of the on pressed. With the nullcheck, because not every button needs an onpressed
      onPressed: () => onPressed == null ? null : onPressed!(),
      child: Row(
        children: [
          // button and text are Prestyled
          Icon(
            icon,
            color: AppColors.stdTextColor,
          ),
          Text(
            text,
            style: TextStyle(color: AppColors.stdTextColor),
          ),
        ],
      ),
    );
  }
}

/// checkbox with text widget
/// its statefull, because the text and the checkbox are covered by a button
/// the button is useful because you dont have to hit the checkbox directly to toggle
class TextCheckbox extends StatefulWidget {
  // not a child, because I only want text in this boxes
  final String? text;
  final bool value;
  // the checkbox on changed function
  final void Function(bool)? onChanged;

  TextCheckbox(
      {Key? key, required this.onChanged, this.text, required this.value})
      : super(key: key);

  @override
  _TextCheckBoxState createState() => _TextCheckBoxState();
}

class _TextCheckBoxState extends State<TextCheckbox> {
  bool value = false;

  /// this is used to set the initial value of the checkbox
  /// but thats not enough
  /// because if the state is not yet loaded in the bloc, the value wont change afterwards
  /// thats why we have to override: didUpdateWidget
  @override
  void initState() {
    value = widget.value;

    super.initState();
  }

  /// this override is used, if the widged is changed externaly, so we have to
  /// update the value
  @override
  void didUpdateWidget(covariant TextCheckbox oldWidget) {
    // TODO: implement didUpdateWidget
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return AppColors.checkboxColor;
    }

    // As button, the Standard textbutton is used of cource
    return StdTextButton(
        onPressed: () {
          // when the button is hit, the checkbox value gets triggered!
          value = !value;
          callOnChanged(value);
          setState(() {});
        },
        child: Row(
          children: [
            Checkbox(
              // the fill color is set by an material stateproperty, the states are
              // similar to css pseudo classes like hover etc!
              // more info: https://api.flutter.dev/flutter/material/Checkbox-class.html
              fillColor: MaterialStateProperty.resolveWith(getColor),
              // if the checkbox is toggled (Not if value is changed externaly!!!; see callOnChanged)
              onChanged: (bool? value) => callOnChanged(value),
              value: value,
            ),
            // the text in this checkbox, with styling
            Text(widget.text != null ? widget.text! : '',
                style: TextStyle(color: AppColors.stdTextColor)),
          ],
        ));
  }

  // because the checkbox' on changed is not called if value is changed externaly
  // and we are using button to change it, the given on changed function has to be called
  // from the button AND the checkbox, so this is an auxiliary function, to avoid code dupplication
  void callOnChanged(bool? value) {
    widget.onChanged == null ? null : widget.onChanged!(value!);
  }
}

class GenericSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearchTextChanged;
  GenericSearchBar(
      {Key? key, required this.controller, required this.onSearchTextChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withOpacity(0.5),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        controller.clear();
                        onSearchTextChanged('');
                      },
                    )))));
  }
}

class FullWidthPaddingInput extends StatelessWidget{
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool password;

  FullWidthPaddingInput({this.controller, this.labelText, this.hintText, this.password = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: password ? true : false,
        enableSuggestions: password ? false: true,
        autocorrect: password ? false: true,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }

}