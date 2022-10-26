import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_widget/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

import '../../../../../domain/event/event.dart';

///
/// Generates an List with [PostWidget] Components that is unscrollable
///
class UnscrollablePostContainer extends StatelessWidget {
  final List<Post> posts;
  final Profile? profile;
  final bool showAuthor;
  final Event? event;

  const UnscrollablePostContainer({Key? key,
    required this.posts,
    this.profile,
    this.event,
    this.showAuthor = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // building the list of post widgets
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // the padding is set to the std padding defined in styling widgets
        padding: stdPadding,
        scrollDirection: Axis.vertical,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostWidget(
              post: posts[index],
              showAuthor: showAuthor,
              event: posts[index].event);
        },
      ),
    );
  }
}


// /// generate list of posts
// Widget generateUnscrollablePostContainer(
//     {required List<Post> posts,
//       Profile? profile,
//       bool showAutor = false,
//       Event? event,
//       BuildContext? context}) {
//   if (posts.isEmpty) {
//     return Column(
//       children: [
//         Text("No Posts available."),
//       ],
//     );
//   }
//   return Column(
//     children: [
//       Container(
//         // building the list of post widgets
//         child: ListView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           // the padding is set to the std padding defined in styling widgets
//           padding: stdPadding,
//           scrollDirection: Axis.vertical,
//           itemCount: posts.length,
//           itemBuilder: (context, index) {
//             return BlocProvider(
//               create: (context) => PostWidgetCubit(post: posts[index]),
//               child: BlocBuilder<PostWidgetCubit, PostWidgetState>(
//                   builder: (context, state) {
//                     return state.maybeMap(
//                         initial: (init) {
//                           return PostWidget(
//                               post: posts[index],
//                               showAuthor: showAutor,
//                               event: posts[index].event,
//                               context: context);
//                         },
//                         loaded: (st) {
//                           return PostWidget(
//                               post: posts[index],
//                               showAuthor: showAutor,
//                               event: posts[index].event,
//                               context: context);
//                         },
//                         edited: (ed) {
//                           return PostWidget(
//                               post: ed.post,
//                               showAuthor: showAutor,
//                               event: posts[index].event,
//                               context: context);
//                         },
//                         error: (err) {
//                           return Text(err.toString());
//                         },
//                         deleted: (del) => SizedBox.shrink(),
//                         orElse: () => const Text("OrELse error in post widget"));
//                   }),
//             );
//           },
//         ),
//       ),
//     ],
//   );
// }