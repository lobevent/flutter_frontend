import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event_profile_picture.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/ImageCarousell.dart';
import 'package:flutter_frontend/presentation/pages/event/event_profile_pictures_page/cubit/epp_page_cubit.dart';

class EppGridListTile extends StatefulWidget {
  final EventProfilePicture epp;

  const EppGridListTile({Key? key, required this.epp}) : super(key: key);

  @override
  State<EppGridListTile> createState() => _EppGridListTileState();
}

class _EppGridListTileState extends State<EppGridListTile>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final endOpacity = 0.3;
  double opacity = 0;

  // indicates ownership of the image
  late bool own;

  @override
  void initState() {
    //BEGIN: --- the fade in animation
    controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    animation = Tween<double>(begin: 0, end: 0.3).animate(controller)
      ..addListener(() {
        this.opacity = animation.value;
        setState(() {});
      });
    //END: --- the fade in animation
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    own = CommonHive.checkIfOwnId(widget.epp.profile.id.value.toString());

    ImageProvider image =
        Image.network(dotenv.env['ipSim']!.toString() + widget.epp.path).image;

    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxWidth: 10, minWidth: 10, maxHeight: 30, minHeight: 30),
      child: Container(
        decoration: BoxDecoration(
            border:
                own ? Border.all(color: AppColors.accentColor, width: 2) : null,
            image: DecorationImage(fit: BoxFit.cover, image: image)),
        child: GestureDetector(
          onTap: () {
            context.read<EppPageCubit>().state.maybeMap(
                orElse: () {},
                loaded: (ls) =>
                    //ImageDialog.showInterActiveImageCarouselOverlay(context, ls.epps.map((e) => e.path).toList())
                    ImageDialog.EppsShowInterActiveImageCarouselOverlay(
                        context,
                        ls.epps,
                        ls.epps.indexWhere((epplist) =>
                            epplist.id.value.toString() ==
                            widget.epp.id.value.toString())));
          },
          onLongPress: () async {
            if (own) {
              controller.forward();
              Future.delayed(Duration(seconds: 2))
                  .then((value) => controller.reverse());
            }
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.black.withOpacity(opacity),
                AppColors.black.withOpacity(1 / endOpacity * opacity),
              ],
            )),
            child: opacity > 0 ? _DeleteButton(context) : null,
          ),
        ),
      ),
    );
  }

  Opacity _DeleteButton(BuildContext context) {
    return Opacity(
      opacity: 1 / endOpacity * opacity,
      child: MaterialButton(
        height: 50,
        shape: const CircleBorder(),
        onPressed: () {
          // reverse the animation fast, so we dont get error, when widet is removed
          controller.reverseDuration = Duration(milliseconds: 200);
          controller.reverse();
          // ask if user is sure to delete the event
          GenDialog.genericDialog(context, AppStrings.genericDeleteTitle,
                  AppStrings.genericDeleteDialogText)
              .then((value) {
            if (value) {
              context.read<EppPageCubit>().deleteEpps(widget.epp, context);
            }
          });
        },
        child: const Icon(Icons.delete_forever),
      ),
    );
  }
}
