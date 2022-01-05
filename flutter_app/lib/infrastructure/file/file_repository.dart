
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class FileRepository{
  final ImagePicker _picker = ImagePicker();
  late XFile image;

  Future<XFile> getImage() async{
      return image = (await _picker.pickImage(source: ImageSource.gallery))!;
  }
  Future<
}
