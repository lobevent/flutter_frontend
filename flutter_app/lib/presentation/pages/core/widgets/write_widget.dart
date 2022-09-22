import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/widgets/post_widget_cubit/post_widget_cubit.dart';

import '../../../../domain/post/post.dart';
import '../../../../domain/event/event.dart';
import '../../../../domain/post/value_objects.dart';
import '../../../core/styles/colors.dart';
import '../../../post_comment/post_screen/cubit/post_screen_cubit.dart';
import 'Post/PostImagePickerWidget.dart';

class WriteWidget extends StatefulWidget{
  final Event event;
  final Event? postEvent;
  final Post? post;
  final BuildContext cubitContext;
  final OverlayEntry? overlayEntry;
  WriteWidget({
    Key? key,
    required this.cubitContext,
    required this.event,
    this.postEvent,
    this.post, this.overlayEntry
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
              if (widget.post == null) PostImagePickerWidget() else Text(""),
              TextWithIconButton(
                  onPressed: () {
                    //post or edit the post
                    widget.post == null
                        ? {widget.cubitContext.read<PostScreenCubit>().postPost(
                        postWidgetController.text, widget.event.id.value.toString()),
                    postWidgetController.clear(),
                    }
                        : {
                      widget.cubitContext.read<PostWidgetCubit>().editPost(
                          widget.post!.copyWith(
                              postContent:
                              PostContent(postWidgetController.text))),
                      //remove overlayentry
                      widget.overlayEntry?.remove(),

                    };
                  },
                  text: "Post")
            ],
          ),
        ));
  }
}
// Widget WriteWidget(BuildContext cubitContext, Event event, {Post? post}) {
//   TextEditingController postWidgetController = TextEditingController();
//   if(post != null){
//     postWidgetController.text = post.postContent.getOrEmptyString();
//   }
//   // post!=null? post.postContent.value
//   //    .fold((l) => l.toString(), (postContent) => postContent.toString())
//
//   return Container(
//       decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
//       width: 300,
//       child: Title(
//         title: "Post something.",
//         color: Colors.black,
//         child: Column(
//           children: [
//             FullWidthPaddingInput(
//               password: false,
//               maxLines: 6,
//               controller: postWidgetController,
//             ),
//             if (post == null) PostImagePickerWidget() else Text(""),
//             TextWithIconButton(
//                 onPressed: () {
//                   post == null
//                       ? cubitContext.read<PostScreenCubit>().postPost(
//                           postWidgetController.text, event.id.value.toString())
//                       : cubitContext.read<PostScreenCubit>().editPost(
//                           post.copyWith(
//                               postContent:
//                                   PostContent(postWidgetController.text)));
//                 },
//                 text: "Post")
//           ],
//         ),
//       ));
// }
