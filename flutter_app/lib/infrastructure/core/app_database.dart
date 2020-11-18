
import 'package:moor_flutter/moor_flutter.dart';
//https://github.com/simolus3/moor/blob/master/moor_flutter/example/lib/database/database.dart

part 'app_database.g.dart';
@UseMoor(tables: [], daos: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
      path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}