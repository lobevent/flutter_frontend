
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';

class UploadFile {
  Future <void> uploadFile(String imagePath) async{
    await SymfonyCommunicator().postFile('/upload/image', imagePath);
}
}