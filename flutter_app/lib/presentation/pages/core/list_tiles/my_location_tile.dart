import 'package:flutter/material.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';

import '../../../../domain/my_location/my_location.dart';

///
/// This tile is for displaying myLocation Entities in a list
/// [location] is an [MyLocation] object, that should be displayed
/// [onDelete] is an Function, that executes the deletion
///
class MyLocationTile extends StatefulWidget {
  final MyLocation location;
  final Future<bool> Function(MyLocation)? onDelete;
  const MyLocationTile({Key? key, required this.location, this.onDelete}) : super(key: key);

  @override
  State<MyLocationTile> createState() => _MyLocationTileState();
}

class _MyLocationTileState extends State<MyLocationTile> {
  bool isDeleting = false;
  bool errorDeleting = false;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      tileColor: isDeleting ? AppColors.deletionOngoingColor : null,
      trailing: widget.onDelete != null? deleteButton() :null,
      leading: Icon(Icons.location_on_outlined),
      title: Center(child: FittedBox(child: Text(widget.location.name.getOrEmptyString()),)),
      subtitle: Center(child: FittedBox(child: Text("${widget.location.address.getOrEmptyString()} at lat${widget.location.latitude}, long: ${widget.location.longitude}"),),)
      );
  }


  Widget deleteButton(){
    return Ink(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.accentButtonColor, width: 1.0),
          //color: Colors.indigo[900],
          shape: BoxShape.circle,
        ), child: IconButton(onPressed: ()=>_onPressed(), icon: Icon(Icons.delete), splashRadius: 24,));
  }

  void _onPressed(){
    GenDialog.genericDialog(context, AppStrings.deleteMyLocationDialogTitle, AppStrings.deleteMyLocationDialogText, AppStrings.deleteMyLocationDialogConfirm, AppStrings.deleteMyLocationDialogAbort)
        .then((value) async {
      // unset the deleting attribute
      if(value){
        this.isDeleting = true;
        setState((){});
        widget.onDelete!(widget.location).then((value) {
          isDeleting = false;
          if(!value){
            // if there was an error deleting, set the flag
            errorDeleting = true;
          }
          setState((){});
        });
      }
    });
  }
}
