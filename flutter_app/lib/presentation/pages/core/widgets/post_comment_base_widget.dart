import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/core/styles/sizes.dart';
import 'package:flutter_frontend/presentation/core/styles/text_styles.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/ImageCarousell.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:intl/intl.dart';

import 'Profile/profile_popup.dart';

class PostCommentBaseWidget extends StatelessWidget {
  /// the post attribute, which contains all the post data
  final Profile? autor;
  final DateTime date;
  final String content;
  final Widget actionButtonsWidgets;
  final List<PopupMenuItem>? popUpItems;
  final List<String> images;
  const PostCommentBaseWidget(
      {Key? key,
      this.autor,
      this.images = const [],
      required this.date,
      required this.content,
      required this.actionButtonsWidgets, this.popUpItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // if you need this
          side: BorderSide(
            color: AppColors.black,
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
        borderOnForeground: true,
        // constrained Box for min height
        child: ConstrainedBox(

            constraints: const BoxConstraints(
              minHeight: 150.0,
              minWidth: 50.0,
            ),
            // column contains the content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add header information (date, author, etc.)
                MetaHeadWidget(date: date, author: autor),
                // content of the post
                ContentWidget(content, context),
                imageCarousell(),
                DateWidgetPost(date, context),
                // actions like comments and likes
                Align(alignment: Alignment.topLeft,child: actionButtonsWidgets,),
              ],
            )));
  }

  /// contains the content of the post
  Widget ContentWidget(String content, BuildContext context) {
    return PaddingRowWidget(children: [
      //prevent overflowing textlines
      Expanded(
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyText1),
        ),
    ]);
  }

  Widget DateWidgetPost(DateTime date, BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: paddingLeftConst - 15),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          DateFormat('EEEE, MMM d, yyyy, HH:mm').format(date),
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
  /// the head meta wiget displays metadata for the post
  Widget MetaHeadWidget({Profile? author = null, required DateTime date}) {
    return PaddingRowWidget(
      // the top padding should be less than the content padding
      paddinfLeft: paddingLeftConst - 15,
      paddingRight: paddingLeftConst - 15,
      children: [
        // if author is null, just user a spacer instead
        if (author == null) Spacer() else ProfilePopup(
                loadingButtonSize: 40,
                isLoading: false,
                profile: author,
              ),
        Spacer(),
        if(popUpItems != null)
          PopupMenuButton(itemBuilder: (BuildContext context) => popUpItems!)
      ],
    );
  }

  Widget imageCarousell() {
    return ImageCarousel(
      imagePaths: images,
      isLoadetFromWeb: true,
    );
  }

  // /// the widget for displaying the author (Overflow Safe)
  // Widget AuthorWidget(Profile profile) {
  //   // row so we can display multiple things
  //   return Row(
  //     children: [
  //       // get avatar image or from assets
  //       CircleAvatar(
  //         backgroundImage: ProfileImage.getAssetOrNetwork(profile.images?[0]),
  //         radius: 10,
  //       ),
  //       // sized box for little distance
  //       SizedBox(
  //         width: 00,
  //       ),
  //       // overflow safe
  //       OverflowSafeString(
  //           child: Text(
  //         profile.name.getOrCrash(),
  //         style: AppTextStyles.stdSubTextStyle,
  //       ))
  //     ],
  //   );
  // }
}
