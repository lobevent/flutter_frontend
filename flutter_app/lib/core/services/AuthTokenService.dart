import 'package:flutter_frontend/data/constants.dart';
import 'package:flutter_frontend/data/storage_strings.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenService {
  final storage = FlutterSecureStorage();

  Future<void> safeToken(String token) async {
    await storage.write(key: StorageStrings.Token, value: token);
  }

  Future<String?> retrieveToken() async {
    return storage.read(key: StorageStrings.Token);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: StorageStrings.Token);
  }
}
