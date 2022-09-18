import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../domain/core/failures.dart';
import '../domain/profile/profile.dart';
import '../infrastructure/profile/profile_repository.dart';

//TODO: use this also for profileid and token, its way faster and easier

class CommonHive {
  static const String achievements= 'achievements';
  static const String ownEvents= 'ownEvents';
  static const String attendingConfirmedEvents= 'attendingConfirmedEvents';
  static const String ownProfileIdAndPic = 'ownProfileIdAndPic';

  ///init the boxes we need
  static Future<void> initBoxes() async {
    await Hive.openBox(ownProfileIdAndPic);
    await Hive.openBox(achievements);
    await Hive.openBox(ownEvents);
    await Hive.openBox(attendingConfirmedEvents);
  }

  /// PROFILE Stuff

  ///saves ownprofile id and pic in hive
  Future<void> safeOwnProfileIdAndPic() async {
    String? ownImage;
    String? ownProfileId;
    //box for storage
    final box = Hive.box(achievements);

    //fetch the own profile from backend
    final Either<NetWorkFailure, Profile> ownProf= await GetIt.I<ProfileRepository>().getOwnProfile();
    final Profile? ownProfile = ownProf.fold((failure) => null,
            (prof) => prof);
                      //try to get the profilePic String
    ownProfileId = ownProfile?.id.value;
                      try{
                        ownImage = ownProfile?.images?[0];
                      }
                      on RangeError catch (exception){
                        ownImage = null;
                      }
                      //set the values to the box, with the keys
                      box.put('ownProfileId', ownProfileId);
                      box.put('ownProfilePic', ownImage ?? "");
  }

  Future<String?> getOwnPic()async{
    return await CommonHive().getBoxEntry("ownProfilePic", ownProfileIdAndPic);
  }

  ///checks if some id is ownProfileId
  bool checkIfOwnId(String checkId) {
    return getBoxEntry('ownProfileId', ownProfileIdAndPic) == checkId;
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

  String? getBoxEntry(String value, String boxName){
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