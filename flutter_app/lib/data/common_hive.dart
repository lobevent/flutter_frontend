import 'package:hive/hive.dart';

//TODO: use this also for profileid and token, its way faster and easier

class CommonHive {
  static const String achievements= 'achievements';
  static const String ownEvents= 'ownEvents';
  static const String attendingConfirmedEvents= 'attendingConfirmedEvents';

  static Future<void> initBoxes() async {
    await Hive.openBox(achievements);
    await Hive.openBox(ownEvents);
    await Hive.openBox(attendingConfirmedEvents);
  }

  static void saveAchievement(String name, bool value){
    final box = Hive.box(achievements);
    box.put(name, value);
  }

static bool? getAchievement(String name){
    final box = Hive.box(achievements);
  }

  static void saveBoxEntry(String value, String boxName){
    final box = Hive.box(boxName);
    box.put(value, value);
  }

  static void deleteBoxEntry(String value, String boxName){
    final box = Hive.box(boxName);
    box.delete(value);
  }

  static String? getBoxEntry(String value, String boxName){
    final box = Hive.box(boxName);
    return box.get(value).toString();
  }

  static List getBoxEntries(String value, String boxName){
    final box = Hive.box(boxName);
    List vals= box.values.toList();
    return vals;
  }


  static void saveAttendingConfirmed(String value){
    final box = Hive.box(attendingConfirmedEvents);
    box.put(value, value);
  }

  static void deleteAttendingConfirmed(String value){
    final box = Hive.box<String>(attendingConfirmedEvents);
    box.delete(value);
  }

  static List getAttendingConfirmed(String value)  {
    final box = Hive.box(attendingConfirmedEvents);
    List vals= box.values.toList();
    return vals;
  }

}