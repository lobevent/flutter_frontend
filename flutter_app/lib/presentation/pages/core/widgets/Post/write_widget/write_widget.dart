import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../domain/post/post.dart';
import '../../../../../../domain/event/event.dart';
import '../../../../../../domain/post/value_objects.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../post_comment/post_screen/cubit/post_screen_cubit.dart';
import 'write_widget_post_image_picker.dart';


///
/// widget used for writing comments or posts
///
class WriteWidget extends StatefulWidget{
  /// [postContent] can also come from an Comment
  /// its just a string, so no boilerplate is there deciding whether it is [Comment] or [Post]
  final String? postContent;

  /// [onSubmit] is the function that is called when the submit button is called.
  /// The function receives the typed in string
  final Function(String postContent) onSubmit;

  /// [changeImages] is only used with post, it receives an [List] of images from the imagepicker
  /// the list might contain only one item
  final Function(List<XFile?> images)? changeImages;
  WriteWidget({
    Key? key,
    required this.onSubmit,
    this.postContent, this.changeImages,

  }): super(key: key);

  @override
  State<WriteWidget> createState() => _WriteWidgetState();
}

class _WriteWidgetState extends State<WriteWidget> {
  late TextEditingController postWidgetController;

  @override
  void initState(){
    super.initState();
    postWidgetController = TextEditingController(text: widget.postContent);
    // if(widget.postContent != null){
    //   postWidgetController = TextEditingController(text: widget.postContent);
    // }
    // else {
    //   postWidgetController = TextEditingController();
    // }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(border: Border.all(color: AppColors.mainIcon)),
        width: 300,
        child: Title(
          title: "Post something.",
          color: AppColors.black,
          child: Column(
            children: [
              FullWidthPaddingInput(
                password: false,
                maxLines: 6,
                controller: postWidgetController,
              ),
              if (widget.postContent == null && widget.changeImages != null) PostImagePickerWidget(changeImages: widget.changeImages!) else Text(""),
              TextWithIconButton(
                  onPressed: () {
                    widget.onSubmit(postWidgetController.text);
                    postWidgetController.clear();
                  },
                  text: "Post")
            ],
          ),
        ));
  }
}