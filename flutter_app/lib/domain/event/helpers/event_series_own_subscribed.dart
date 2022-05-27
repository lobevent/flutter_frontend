import '../event_series.dart';

class OwnAndSubscribedEventSeries{
  List<EventSeries> own;
  List<EventSeries> subscribed;

  OwnAndSubscribedEventSeries({this.own = const [], this.subscribed = const []});

}