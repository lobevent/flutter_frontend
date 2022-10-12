library stlyling_widgets;

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dartz/dartz.dart' show left, Either;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/core_widgets_stylings_text_with_icon.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/std_choice_text_chip.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/chip_choice.dart';

export 'package:flutter_frontend/presentation/pages/core/widgets/stylings/CarouselIndicators.dart';
export 'package:flutter_frontend/presentation/pages/core/widgets/stylings/dismissible_overlay.dart';
export 'package:flutter_frontend/presentation/pages/core/widgets/stylings/outlined_non_overflow_button_with_text.dart';
export 'package:flutter_frontend/presentation/pages/core/widgets/stylings/core_widgets_stylings_text_with_icon.dart';
export 'package:flutter_frontend/presentation/pages/core/widgets/stylings/std_choice_text_chip.dart';
export 'package:flutter_frontend/presentation/pages/core/widgets/stylings/chip_choice.dart';

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
  final Either<List<Widget>, Widget> child_ren;
  final bool scrollable;
  final ScrollController? controller;
  // https://stackoverflow.com/questions/54114221/flutter-fixed-button-in-customscrollview
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;
  final bool isLoading;
  const BasicContentContainer(
      {Key? key,
      required this.child_ren,
      this.bottomNavigationBar,
      this.controller,
      this.appBar,
      this.scrollable = true,
      this.floatingActionButton,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //assert(onlyChild == true && child != null || onlyChild == false && children != null);
    return Scaffold(
      floatingActionButton: floatingActionButton ?? null,
      appBar: appBar,
      body: ColorfulSafeArea(
          color: AppColors.mainIcon,
          child: LoadingOverlay(
            isLoading: isLoading,
            child: ScrollOrNotChild(),
          )),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  /**
   * Depending on wether the scroll parameter is set true, this either returns
   * an scrollview or just an column
   */
  Widget ScrollOrNotChild() {
    return child_ren.fold((children) {
      if (scrollable) {
        return SingleChildScrollView(
          controller: controller,
          child: Column(
            children: children,
          ),
        );
      } else {
        return Column(
          children: children,
        );
      }
    }, (child) {
      return child;
    });
  }
}

/// this is an basic Tab that can be Used in tab bar
/// it has automatic padding at both ends
/// it takes an String text and an icon
class StdSpacedIconTextTab extends StatelessWidget {
  final String text;
  final IconData iconHere;
  //late Widget child;
  const StdSpacedIconTextTab(
      {Key? key, required this.text, required this.iconHere})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacer(),
        Tab(child: TextWithIcon(text: text, icon: iconHere)),
        const Spacer()
      ],
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

  /// decision if the container should be centered
  final bool centered;

  const PaddingRowWidget(
      {Key? key,
      required this.children,
      this.paddinfLeft = paddingLeftConst,
      this.paddingTop = paddingTopConst,
      this.paddingRight = paddingRightConst,
      this.paddingBottom = paddingBottomConst,
      this.centered = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (centered) {
      return Center(
        child: ThePaddingWidged(),
      );
    } else {
      return ThePaddingWidged();
    }
  }

  Widget ThePaddingWidged() {
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
            color: disabled ? AppColors.lightGrey : AppColors.darkGrey,
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
  final bool withSpacer;
  const TextWithIconButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.icon,
      this.disabled = false, this.withSpacer = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StdTextButton(
      disabled: disabled,
      // the call of the on pressed. With the nullcheck, because not every button needs an onpressed
      onPressed: () => onPressed == null ? null : onPressed!(),
      // commented out, if error arises, pls make an bool with expanded or not
      //child: Expanded(
      child: Row(
        children: [
          if(withSpacer) Spacer(),
          // button and text are Prestyled
          Icon(
            icon,
            color: AppColors.stdTextColor,
          ),

          if(withSpacer) Spacer(),
          Text(
            text,
            style: TextStyle(color: AppColors.stdTextColor),
          ),
          if(withSpacer) Spacer(),
        ],
      //),
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
        color: AppColors.overlayBGColor.withOpacity(0.5),
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


class FullWidthPaddingInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool password;
  final int? maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final EdgeInsets padding;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autoValidateMode;
  final FocusNode? fieldFocusNode;

  FullWidthPaddingInput(
      {this.controller,
      this.labelText,
      this.hintText,
      this.password = false,
      this.maxLines,
      this.maxLength,
      this.validator,
      this.onChanged,
      this.textInputType,
      this.padding = const EdgeInsets.all(10),
      this.inputFormatters, this.autoValidateMode, this.fieldFocusNode,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        obscureText: password ? true : false,
        enableSuggestions: password ? false : true,
        autocorrect: password ? false : true,
        focusNode: fieldFocusNode,
        controller: controller,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines != null ? maxLines : 1,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
        keyboardType: textInputType,
        autovalidateMode: autoValidateMode,
        inputFormatters: inputFormatters,
      ),
    );
  }
}


class CoordinatesPickerInput extends StatelessWidget {
  const CoordinatesPickerInput({
    Key? key,
    required this.textEditingControllerLongi, required this.labeltext, this.onChanged,
  }) : super(key: key);

  final TextEditingController textEditingControllerLongi;
  final String labeltext;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return FullWidthPaddingInput(
      // autoValidateMode: AutovalidateMode.onUserInteraction,
      labelText: labeltext,
      controller: textEditingControllerLongi,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890.-]'))],
      onChanged: (value2) => onChanged,
      textInputType: TextInputType.numberWithOptions(decimal: true, signed: true),
      validator: (value){
        if(value == null || value == ''){
          return 'please provide an $labeltext';
        }
      },
    );
  }
}
