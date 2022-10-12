import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../domain/core/failures.dart';
import '../domain/profile/profile.dart';
import '../infrastructure/profile/profile_repository.dart';

//TODO: use this also for profileid and token, its way faster and easier

class CommonHive {
  static const String achievements = 'achievements';
  static const String ownEvents = 'ownEvents';
  static const String attendingConfirmedEvents = 'attendingConfirmedEvents';
  static const String ownProfileIdAndPic = 'ownProfileIdAndPic';

  ///init the boxes we need
  static Future<void> initBoxes() async {
    await Hive.openBox<String>(ownProfileIdAndPic);
    await Hive.openBox<bool>(achievements);

  }

  ///delete hive storage
  static Future<void> deleteHive() async{
    final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);
    await Hive.deleteFromDisk();
    print("Hive got deleted!");
  }

  /// PROFILE Stuff

  ///saves ownprofile id and pic in hive
  static Future<void> safeOwnProfileIdAndPic() async {
    String? ownImage;
    String? ownProfileId;
    //fetch the own profile from backend
    await GetIt.I<ProfileRepository>().getOwnProfile().then((value) => value.fold(
            (l) => null, (ownProfile) {
              CommonHive.saveBoxEntry<String>(ownProfile.id.value.toString(), "ownProfileId", ownProfileIdAndPic);
              try {
                ownImage = ownProfile.images?[0];
              } on RangeError catch (exception) {
                ownImage = null;
              }
              if(ownImage!=null){
                CommonHive.saveBoxEntry<String>(ownImage!, "ownProfilePic", ownProfileIdAndPic);
              }
      } ));
  }

  static Future<String?> getOwnPic() async {
    return CommonHive.getBoxEntry<String>("ownProfilePic", ownProfileIdAndPic);
  }

  ///checks if some id is ownProfileId
  static bool checkIfOwnId(String checkId) {
    return CommonHive.getBoxEntry<String>('ownProfileId', ownProfileIdAndPic) == checkId;
  }

  static void saveAchievement(String key) {
    final box = Hive.box<bool>(achievements);
    box.put(key, true);
  }


  static List<String> getAchievements(){
    final box = Hive.box<bool>(achievements);
    final List<String> values = box.keys.map((e) => e.toString()).toList();
    return values;
  }

  static bool? getAchievement(String key) {
    final box = Hive.box<bool>(achievements);
    final bool? val = box.get(key);
    return val;
  }

  static void saveBoxEntry<T>(T value, String key, String boxName) {
    final box = Hive.box<T>(boxName);
    box.put(key, value);
  }

  static void deleteBoxEntry<T>(T value, String boxName) {
    final box = Hive.box<T>(boxName);
    box.delete(value);
  }

  static T? getBoxEntry<T>(String key, String boxName) {
    final box = Hive.box<T>(boxName);
    final T? val = box.get(key);
    return val;
  }

  static List<dynamic> getBoxEntries<T>(String boxName) {
    final box = Hive.box<T>(boxName);
    final List vals = box.values.toList();
    return vals;
  }
}
