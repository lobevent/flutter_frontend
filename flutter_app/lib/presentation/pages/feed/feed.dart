import 'package:auto_route/auto_route.dart' hide Router;
import 'package:dartz/dartz.dart' show left, Either;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/main_app_bar.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/feed/cubit/feed_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import '../../../domain/event/event.dart';
import '../event/core/event_list_tiles/event_list_tiles.dart';
import '../event/events_multilist/cubit/events_mulitlist_cubit.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Event> events =[];

  Widget child = Text('');
  Widget LoadingIndicatorOrEnd = Container();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
            create: (context) => FeedCubit(),
            child: BlocConsumer<FeedCubit, FeedState>(
              listener: (context, state){
                if(state.isLoadingNew){
                  LoadingIndicatorOrEnd  = CircularProgressIndicator();
                }else{
                  if(state.endReached){
                    LoadingIndicatorOrEnd = Text(AppStrings.endReached);
                  }else {
                    LoadingIndicatorOrEnd = Container();
                  }
          }

                child = state.error.isSome() ? ErrorMessage(errorText: state.error.fold(() {}, (a) => a)) :
                    Column (children: [Container(child:itemBuilder(state.events, null) ,)],) ;
                //generateUnscrollablePostContainer(posts: state.posts , showAutor: true);
                setState(() {events = state.events;

                });
              },
              // buildWhen: (previousState, state) {
              //   return previousState.isLoading != state.isLoading;
              // },
              buildWhen: (previus, current){
                return previus.isLoading != current.isLoading;
              },
              builder: (context, state) {
                return BasicContentContainer(
                  controller: context.read<FeedCubit>().controller,
                  appBar: MainAppBar(),
                  bottomNavigationBar: const BottomNavigation(selected: NavigationOptions.home),
                  child_ren: left([
                    LoadingOverlay(
                      isLoading: state.isLoading,
                      child:  Column(
                          children: [
                            child,
                            LoadingIndicatorOrEnd
                          ]), )
                  ]),
                );
              },
            ),
    );
  }
  Widget itemBuilder(List<Event> events, EventStatus? userEventStatus) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // the padding is set to the std padding defined in styling widgets
        padding: stdPadding,
        scrollDirection: Axis.vertical,
        itemCount: events.length,
        itemBuilder: (context, index){
          if (events[index].failureOption.isSome()) {
            return Ink(
                color: Colors.red,
                child: ListTile(
                  title:
                  Text(events[index].failureOption.fold(() => "", (a) => a.toString())),
                ));
          }
          if (this.events.isEmpty ) {
            return Ink(
                color: Colors.red,
                child: const ListTile(title: Text("No events available")));
          } else {
            if(events[index].date.isBefore(DateTime.now())){
              return PostCommentBaseWidget(date: events[index].date, content: events[index].name.toString(), actionButtonsWidgets: Text(''));
            }
            return EventListTiles(
              key: ObjectKey(events[index]),
              eventStatus: userEventStatus,
              isInvitation: false,
              event: events[index],
              onDeletion: null,
            );
          }
        });

  }



}
