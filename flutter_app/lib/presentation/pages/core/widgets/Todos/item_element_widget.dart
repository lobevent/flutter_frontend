import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:get_it/get_it.dart';

import '../../../../../data/storage_shared.dart';
import '../../../../../domain/event/event.dart';
import '../../../event/event_screen/cubit/add_people_item/add_people_item_cubit.dart';
import '../add_friends_dialog.dart';
import '../loading_overlay.dart';

class ItemElementWidget extends StatefulWidget {
  final Item item;
  final String name;
  final String description;
  final List<Profile> profiles;
  final Function(Item item)? deleteItemFunc;
  final Function(Item item)? editItemFunc;
  final Function(Item item, Profile? profile)? assignProf;
  final Function(Item item, Profile? profile)? deassignProf;
  final Function(Item item)? addPeopleToItemFunc;
  final Event event;

  const ItemElementWidget(
      {required this.item,
      required this.name,
      required this.description,
      required this.profiles,
      required this.event,
      this.deleteItemFunc,
      this.editItemFunc,
      this.assignProf,
      this.deassignProf,
      this.addPeopleToItemFunc});

  @override
  State<ItemElementWidget> createState() => _ItemElementWidgetState();
}

class _ItemElementWidgetState extends State<ItemElementWidget> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return buildListtile(widget.editItemFunc != null);
  }

  //seperate to fix the editItem
  Widget buildListtile(bool editItem) {
    return ListTile(
      tileColor: isDeleting ? Color(0x28FF0000) : null,
      leading: Icon(
          Icons.check_circle_outline_outlined), //Todo Userlogos displayed here
      title: Text(widget.name), //the name of the todoitem
      // the assigned profiles
      subtitle:
          Text(widget.description + "\n" + profileNames(widget.item.profiles!)),
      trailing: FittedBox(
        //TODO fix bs design
        fit: BoxFit.fill,
        child: Row(
            children: actionButtons(widget.deleteItemFunc != null,
                widget.addPeopleToItemFunc != null)),
      ),
      onTap: () {
        widget.editItemFunc!(widget.item);
      },
      onLongPress: () {
        //TODO: deassignen verbieten wenn paar h vorher?
        //deassign profile to todo item
        String? ownId = GetIt.I<StorageShared>().getOwnProfileId();
        if (widget.item.profiles!
            .map((e) => e.id.value)
            .contains(GetIt.I<StorageShared>().getOwnProfileId())) {
          widget.deassignProf!(widget.item, null);
        } else {
          widget.assignProf!(widget.item, null);
        }
      },
    );
  }

  // extract the assigned profile names
  String profileNames(List<Profile> profiles) {
    String profileNameList = "";
    for (var i = 0; i < profiles.length; i++) {
      String profileNameI =
          profiles[i].name.value.fold((l) => l.toString(), (r) => r.toString());
      profileNameList = "$profileNameI";
    }
    return profileNameList;
  }

  List<Widget> actionButtons(bool deleteItem, bool addPeopleToItem) {
    //check if we are the host so we can assign people to items
    return [
      if (widget.event.isHost == true)
        IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (noCubitContext) {
                  return BlocProvider(
                    create: (contextCubit) => AddPeopleItemCubit(widget.event),
                    child: BlocBuilder<AddPeopleItemCubit, AddPeopleItemState>(
                      builder: (builderContext, state) {
                        return state.map(
                            // loading state
                            loadingPeople: (state) => LoadingOverlay(
                                child: Text(''), isLoading: true),
                            // loaded state
                            loadedPeople: (state) {
                              // show the add friends dialog
                              return AddFriendsDialog(
                                //TODO: maybe remove the already assigned people from item
                                friends: state.people,
                                //get the invitations from the event
                                invitedFriends: [],
                                // add friend function
                                onAddFriend: (friend) {
                                  if (widget.item.profiles!
                                      .map((e) => e.id.value)
                                      .contains(friend.id.value)) {
                                    widget.deassignProf!(widget.item, null);
                                  } else {
                                    widget.assignProf!(widget.item, null);
                                  }
                                },
                                //remove friend function
                                onRemoveFriend: (friend) {
                                  widget.deassignProf!(widget.item, friend);
                                },
                                assignedTodoItem: widget.item,
                              );
                            },
                            //error state
                            error: (state) => Text(state.failure.toString()));
                      },
                    ),
                  );
                });
          },
          icon: Icon(Icons.add),
        )
      else
        Text(""),
      if (widget.event.isHost == true)
        IconButton(
            onPressed: () {
              //deactivate button if deleting is alredy ongoing
              if (!isDeleting) widget.deleteItemFunc!(widget.item);
              //this.isDeleting = true;
              setState(() {});
            },
            icon: Icon(Icons.delete))
    ];
  }
}
