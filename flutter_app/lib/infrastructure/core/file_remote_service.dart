
import 'dart:io';

import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';

class UploadFile {
  Future <void> uploadFile(File imagePath) async{
    await SymfonyCommunicator().postFile('/upload/image', imagePath);
}
}