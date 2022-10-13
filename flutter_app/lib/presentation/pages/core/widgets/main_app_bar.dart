import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/data/common_hive.dart';
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
      actions: [LeadingButton(context), AddSeriesButton(context), ShowSeriesButton(context), MyLocationsButton(context), MyLocationsFormButton(context), TEST_EventOverview(context), LogoutButton(context)],
    );
  }

  Widget LeadingButton(BuildContext context){
    return IconButton(
        onPressed: (){
          context.router.push(EventFormPageRoute());
        },
        icon: const Icon(Icons.add));
  }


  Widget TEST_EventOverview(BuildContext context){
    return IconButton(
        onPressed: (){
          context.router.push(EventOverviewPageRoute());
        },
        icon: const Icon(Icons.add_a_photo));
  }

  Widget MyLocationsButton(BuildContext context){
    return IconButton(
        onPressed: (){
          context.router.push(MyLocationsPageRoute());
        },
        icon: const Icon(Icons.location_on_outlined));
  }


  Widget MyLocationsFormButton(BuildContext context){
    return IconButton(
        onPressed: (){
          context.router.push(MyLocationFormRoute());
        },
        icon: const Icon(Icons.format_align_center));
  }

  Widget AddSeriesButton(BuildContext context){
    return IconButton(
        onPressed: (){
          context.router.push(EventSeriesFormMainRoute());
        },
        icon: const Icon(Icons.add_alert));
  }

  Widget ShowSeriesButton(BuildContext context){
    return IconButton(
        onPressed: (){
          context.router.push(EventSeriesListPageRoute());
        },
        icon: const Icon(Icons.label_important_outlined));
  }


  Widget OwnProfile(BuildContext context){
    Future<String?> image = CommonHive.getOwnPic();
    //StorageShared().getOwnProfileImage();
    return FutureBuilder<String?>(
      future: image,
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot){
          return IconButton(onPressed: (){
            context.router.push(ProfilePageRoute(profileId: UniqueId.fromUniqueString('')));
          }, icon: CircleAvatar(
            radius: 30,
            backgroundImage: ProfileImage.getAssetOrNetwork(snapshot.data),
          ));
        }
    );
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
//
//
// class OwnProfile extends StatefulWidget {
//   const OwnProfile({Key? key}) : super(key: key);
//
//   @override
//   State<OwnProfile> createState() => _OwnProfileState();
// }
//
// class _OwnProfileState extends State<OwnProfile> {
//   Future<String?> image = StorageShared().getOwnProfileImage();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String?>(
//         future: image,
//         builder: (BuildContext context, AsyncSnapshot<String?> snapshot){
//           if(snapshot.hasData){
//             print(snapshot.data);
//             print(snapshot.data);
//             return IconButton(onPressed: (){
//               context.router.push(ProfilePageRoute(profileId: UniqueId.fromUniqueString('')));
//             }, icon: CircleAvatar(
//               radius: 30,
//               backgroundImage: ProfileImage.getAssetOrNetwork(snapshot.data),
//             ));
//           }
//           if(snapshot.hasError){
//             print("error");
//           }
//
//           return Text("2");
//         }
//     );
//   }
// }
