import 'package:flutter_frontend/domain/event/event.dart';
import '../post/post.dart';

class EventAndPostCarriers {
  List<Event> events;
  List<Post> posts;

  EventAndPostCarriers({this.events = const [], this.posts = const []});
}

class EventAndPostCarrier {
  Event? event;
  Post? post;

  EventAndPostCarrier({this.event = null, this.post = null});
}

List<EventAndPostCarrier> generateSingleCarriers(
    EventAndPostCarriers eventsAndPostsCarrier) {
  List<EventAndPostCarrier> evPostCarrierList = eventsAndPostsCarrier.events
      .map((e) => EventAndPostCarrier(event: e))
      .toList();
  evPostCarrierList.addAll(eventsAndPostsCarrier.posts
      .map((e) => EventAndPostCarrier(post: e))
      .toList());
  evPostCarrierList.shuffle();

  return evPostCarrierList;
}
