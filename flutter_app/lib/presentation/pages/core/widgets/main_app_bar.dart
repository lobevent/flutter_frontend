import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/data/storage_shared.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import 'imageAndFiles/image_classes.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{

  @override
  final Size preferredSize;


  MainAppBar({Key? key}): preferredSize = Size.fromHeight(40), super(key: key);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      leading: OwnProfile(context),
      actions: [LeadingButton(context), AddSeriesButton(context), LogoutButton(context)],
    );
  }

  Widget LeadingButton(BuildContext context){
    return IconButton(
        onPressed: (){
          context.router.push(EventFormPageRoute());
        },
        icon: const Icon(Icons.add));
  }

  Widget AddSeriesButton(BuildContext context){
    return IconButton(
        onPressed: (){
          context.router.push(EventSeriesFormMainRoute());
        },
        icon: const Icon(Icons.add_alert));
  }


  Widget OwnProfile(BuildContext context){
    return IconButton(onPressed: (){
      context.router.push(ProfilePageRoute(profileId: UniqueId.fromUniqueString('')));
    }, icon: CircleAvatar(
      radius: 30,
      backgroundImage: ProfileImage.getAssetOrNetwork(StorageShared().getOwnProfileImage()),
    ));
  }


  Widget LogoutButton(BuildContext context){
    return IconButton(onPressed: ()async{
      await GenDialog.genericDialog(context, "Logout?",
          "Willst du dich wirklich ausloggen?", "Logout", "Abbrechen")
          .then((value) async => {
        if (value)
          context.router
              .push(LoginRegisterRoute())
        else
          {}
      });
    }, icon: Icon(Icons.login),
    );
  }



}