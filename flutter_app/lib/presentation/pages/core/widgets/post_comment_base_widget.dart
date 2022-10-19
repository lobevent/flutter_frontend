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
  final List<String> images;
  const PostCommentBaseWidget(
      {Key? key,
      this.autor,
      this.images = const [],
      required this.date,
      required this.content,
      required this.actionButtonsWidgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
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
              children: [
                // Add header information (date, author, etc.)
                MetaHeadWidget(date: date, author: autor),
                // content of the post
                ContentWidget(content),
                imageCarousell(),
                // actions like comments and likes
                actionButtonsWidgets,
              ],
            )));
  }

  /// contains the content of the post
  Widget ContentWidget(String content) {
    return PaddingRowWidget(children: [
      //prevent overflowing textlines
      Expanded(
        child: Text(
          content,
          style: const TextStyle(color: AppColors.stdTextColor),
        ),
      )
    ]);
  }

  /// the head meta wiget displays metadata for the post
  Widget MetaHeadWidget({Profile? author = null, required DateTime date}) {
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
        author == null
            ? Spacer()
            : ProfilePopup(
                loadingButtonSize: 40,
                isLoading: false,
                profile: author,
              ),
      ],
    );
  }

  Widget imageCarousell() {
    return ImageCarousel(
      imagePaths: images,
      isLoadetFromWeb: true,
    );
  }

  /// the widget for displaying the author (Overflow Safe)
  Widget AuthorWidget(Profile profile) {
    // row so we can display multiple things
    return Row(
      children: [
        // get avatar image or from assets
        CircleAvatar(
          backgroundImage: ProfileImage.getAssetOrNetwork(profile.images?[0]),
          radius: 10,
        ),
        // sized box for little distance
        SizedBox(
          width: 20,
        ),
        // overflow safe
        OverflowSafeString(
            child: Text(
          profile.name.getOrCrash(),
          style: AppTextStyles.stdSubTextStyle,
        ))
      ],
    );
  }
}
