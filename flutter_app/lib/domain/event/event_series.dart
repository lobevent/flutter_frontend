import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';

class EventSeries{
  final UniqueId id;
  final EventName name;
  final EventDescription description;

  EventSeries({required this.name, required this.description, required this.id,});
}