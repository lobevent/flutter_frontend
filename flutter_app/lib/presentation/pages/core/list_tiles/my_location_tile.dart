import 'package:flutter/material.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';

import '../../../../domain/my_location/my_location.dart';

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
      title:

      Row(
        children: [
        Spacer(),
        FittedBox(child: Text(widget.location.name),),
        Spacer(),
        if(widget.onDelete != null)
          IconButton(
              onPressed: ()=>_onPressed(),
              icon: Icon(Icons.delete))],),


      subtitle: Center(child: FittedBox(child: Text("${widget.location.address}at lat${widget.location.latitude}, long: ${widget.location.longitude}"),),)
      );
  }




  void _onPressed(){
    GenDialog.genericDialog(context, AppStrings.deleteMyLocationDialogTitle, AppStrings.deleteMyLocationDialogText, AppStrings.deleteMyLocationDialogConfirm, AppStrings.deleteMyLocationDialogAbort)
        .then((value) async {
      // unset the deleting attribute
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
    });
  }
}
