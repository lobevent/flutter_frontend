import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/loading_button.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/es_ec_UesMenuButton.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import '../../../../../domain/profile/profile.dart';
import '../../../../core/styles/text_styles.dart';
import '../imageAndFiles/image_classes.dart';

class ProfilePopup extends StatefulWidget {
  final Profile profile;
  final bool isLoading;
  final double loadingButtonSize;
  final bool deactivated;

  const ProfilePopup(
      {Key? key,
      required this.profile,
      required this.isLoading,
      required this.loadingButtonSize,
      this.deactivated = false})
      : super(key: key);

  @override
  _ProfilePopupState createState() => _ProfilePopupState();
}

class _ProfilePopupState extends State<ProfilePopup> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return LoadingButton(size: widget.loadingButtonSize);
    }

    return PopupMenuButton(
        child: Row(
          children: [
            //unpopupped widgets
            // get avatar image or from assets
            CircleAvatar(
              backgroundImage:
                  ProfileImage.getAssetOrNetwork(widget.profile.images?[0]),
              radius: 10,
            ),
            // sized box for little distance
            SizedBox(
              width: 20,
            ),
            // overflow safe
            OverflowSafeString(
                child: Text(
              widget.profile.name.getOrCrash(),
              style: AppTextStyles.stdSubTextStyle,
            ))
          ],
        ),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuWidget(
              height: 200,
              //child: InkWell(
              child: PaddingRowWidget(
                paddinfLeft: 20,
                paddingRight: 20,
                children: [
                  InkWell(
                      //what to display in popup
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundImage: ProfileImage.getAssetOrNetwork(
                                widget.profile.images?[0]),
                            radius: 50,
                          ),
                          OverflowSafeString(
                              child: Text(
                            widget.profile.name.getOrCrash(),
                            style: AppTextStyles.stdSubTextStyle,
                          ))
                        ],
                      ),
                      onTap: () {
                        //send to profile page
                        context.router.push(
                            ProfilePageRoute(profileId: widget.profile.id));
                        Navigator.pop(context);
                      }),
                ],
              ),
              /* onTap: () {
                      context.router
                          .push(ProfilePageRoute(profileId: widget.profile.id));
                      Navigator.pop(context);


                    })
                    */
            )
          ];
        });
  }
}
