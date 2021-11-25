import 'package:flutter_frontend/infrastructure/todo/todo_remote_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Test the serializeModel serialization function", () async {
    TodoRemoteService todo = TodoRemoteService();
    await todo.getSingle("e6837df8-9e99-4f00-a40d-0e798834e9da");
    print(await todo.getSingle("e6837df8-9e99-4f00-a40d-0e798834e9da"));
  });
}
