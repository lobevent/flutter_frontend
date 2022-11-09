import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/types/hive_position.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../../../domain/core/failures.dart';
import '../../../../domain/profile/profile.dart';
import '../../../profile/profile_repository.dart';

//part 'types/PositionAdapter.dart';

//TODO: use this also token, its way faster and easier

// ignore: avoid_classes_with_only_static_members
class CommonHive {
  static const String achievements = 'achievements';
  static const String ownProfileIdAndPic = 'ownProfileIdAndPic';
  static const String ownPosition = 'ownPosition';
  static const String searchHistory = 'searchHistory';

  static const String ownProfileIdBoxString = "ownProfileId";

  ///init the boxes we need
  static Future<void> initBoxes() async {
    await Hive.openBox<String>(ownProfileIdAndPic);
    await Hive.openBox<bool>(achievements);
    Hive.registerAdapter(HivePositionAdapter());
    await Hive.openBox<HivePosition>(ownPosition);
    await Hive.openBox<String>(searchHistory);
  }

  ///delete hive storage
  static Future<void> deleteHive() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
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
    if (CommonHive.getBoxEntry<String>("ownProfileId", ownProfileIdAndPic) ==
        null) {
      await GetIt.I<ProfileRepository>()
          .getOwnProfile()
          .then((value) => value.fold((l) => null, (ownProfile) {
                CommonHive.saveBoxEntry<String>(
                    ownProfile.name.getOrEmptyString(),
                    "ownProfileName",
                    ownProfileIdAndPic);
                CommonHive.saveBoxEntry<String>(ownProfile.id.value.toString(),
                    ownProfileIdBoxString, ownProfileIdAndPic);
                try {
                  ownImage = ownProfile.images?[0];
                } on RangeError catch (exception) {
                  ownImage = null;
                }
                if (ownImage != null) {
                  CommonHive.saveBoxEntry<String>(
                      ownImage!, "ownProfilePic", ownProfileIdAndPic);
                }
              }));
    }
  }

  static Future<String?> getOwnPic() async {
    return CommonHive.getBoxEntry<String>("ownProfilePic", ownProfileIdAndPic);
  }

  static String? getOwnProfileName() {
    return CommonHive.getBoxEntry<String>("ownProfileName", ownProfileIdAndPic);
  }

  static String? getOwnProfileId() {
    return CommonHive.getBoxEntry<String>(
        ownProfileIdBoxString, ownProfileIdAndPic);
  }

  ///checks if some id is ownProfileId
  static bool checkIfOwnId(String checkId) {
    return CommonHive.getBoxEntry<String>(
            ownProfileIdBoxString, ownProfileIdAndPic) ==
        checkId;
  }

  static void saveAchievement(String key) {
    final box = Hive.box<bool>(achievements);
    box.put(key, true);
  }

  static void safeThemeMode(bool darkModeEnabled){
    final box = Hive.box<bool>(achievements);
    box.put("darkModeEnabled", darkModeEnabled);
  }

  static bool getDarkMode(){
    final box = Hive.box<bool>(achievements);
    bool? val = box.get("darkModeEnabled");
    return val??true;
  }

  static List<String> getAchievements() {
    final box = Hive.box<bool>(achievements);
    final List<String> values = box.keys.map((e) => e.toString()).toList();
    return values;
  }

  static bool? getAchievement(String key) {
    final box = Hive.box<bool>(achievements);
    final bool? val = box.get(key);
    return val;
  }

  static Future<void> saveSearchHistory(List<String>? searchHistorySave) async {
    final box = Hive.box<String>(searchHistory);
    await box.clear();
    if (searchHistorySave != null) {
      box.addAll(searchHistorySave);
    } else {}
  }

  static List<String>? getSearchHistory() {
    final box = Hive.box<String>(searchHistory);
    final List<String>? vals = box.values.map((e) => e.toString()).toList();
    return vals;
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
