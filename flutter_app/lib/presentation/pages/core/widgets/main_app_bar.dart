import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{

  @override
  final Size preferredSize;


  MainAppBar({Key? key}): preferredSize = Size.fromHeight(40), super(key: key);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      leading: LeadingButton(context),
      actions: [AddSeriesButton(context)],
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



}