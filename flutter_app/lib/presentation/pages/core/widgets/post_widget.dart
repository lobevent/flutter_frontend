import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:intl/intl.dart';

/// this is the post widget, which should be used everywhere
class PostWidget extends StatelessWidget{
  /// the post attribute, which contains all the post data
  final Post post;
  const PostWidget({Key? key, required this.post}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // constrained Box for min height
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 150.0,
          minWidth: 50.0,
        ),
        // column contains the content
        child: Column(
        children: [
          // Add header information (date, author, etc.)
          MetaHeadWidget(date: post.creationDate),
          // content of the post
          ContentWidget(post.postContent.getOrCrash()),

        ],
      )
      )
    );
  }


  /// contains the content of the post
  Widget ContentWidget(String content){
    return PaddingRowWidget(children:
    [

      Text(content,
        style: const TextStyle(color: Color(0xFF400909)),)
    ]);
  }

  /// the head meta wiget displays metadata for the post
  Widget MetaHeadWidget({Profile? author = null, required DateTime date}){
    return PaddingRowWidget(
      // the top padding should be less than the content padding
      paddinfLeft: paddingLeftConst - 15,
      paddingRight: paddingLeftConst - 15,
      children: [
        Text(
          DateFormat('EEEE, MMM d, yyyy').format(date),
          style: const TextStyle(
            color: AppColors.stdTextColor,
            fontSize: AppSizes.metaSubText,
          ),
        ),
        Spacer(),
        // if author is null, just user a spacer instead
        author == null ? Spacer() : AuthorWidget(author),
      ],
    );
  }

  /// the widget for displaying the author (Overflow Safe)
  Widget AuthorWidget(Profile profile){
    // row so we can display multiple things
    return Row(
      children: [
        // get avatar image or from assets
        CircleAvatar(backgroundImage: ProfileImage.getAssetOrNetwork(null), radius: 10,),
        // sized box for little distance
        SizedBox(width: 20,),
        // overflow safe
        OverflowSafeString(child:
          Text(profile.name.getOrCrash(), style: AppTextStyles.stdSubTextStyle,)
        )
        
      ],
    );
  }
}