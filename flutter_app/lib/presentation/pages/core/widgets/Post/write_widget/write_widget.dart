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

class WriteWidget extends StatefulWidget{
  final Post? post;
  final Function(String postContent) onSubmit;
  final Function(List<XFile?> images) changeImages;
  WriteWidget({
    Key? key,
    required this.onSubmit,
    this.post, required this.changeImages,

  }): super(key: key);

  @override
  State<WriteWidget> createState() => _WriteWidgetState();
}

class _WriteWidgetState extends State<WriteWidget> {
  late TextEditingController postWidgetController;

  @override
  void initState(){
    super.initState();
    if(this.widget.post != null){
      postWidgetController = TextEditingController(text: widget.post!.postContent.getOrEmptyString());
    }
    else {
      postWidgetController = TextEditingController();
    }
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
              if (widget.post == null) PostImagePickerWidget(changeImages: widget.changeImages) else Text(""),
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