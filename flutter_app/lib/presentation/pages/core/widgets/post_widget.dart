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
      child: Column(
        children: [
          MetaHeadWidget(date: post.creationDate),
          ContentWidget(post.postContent.getOrCrash()),
        ],
      )
    );
  }


  Widget ContentWidget(String content){
    return PaddingRowWidget(children:
    [
      Text(content,
        style: const TextStyle(color: Color(0xFF400909)),)
    ]);
  }

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
        author == null ? Spacer() : AuthorWidget(author),
      ],
    );
  }

  /// the widget for displaying the author (Overflow Safe)
  Widget AuthorWidget(Profile profile){
    return Row(
      children: [
        // get avatar image or from assets
        CircleAvatar(backgroundImage: ProfileImage.getAssetOrNetwork(null), radius: 10,),
        SizedBox(width: 20,),
        // overflow safe
        OverflowSafeString(child:
          Text(profile.name.getOrCrash(), style: AppTextStyles.stdSubTextStyle,)
        )
        
      ],
    );
  }
}