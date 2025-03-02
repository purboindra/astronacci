import 'package:image_picker/image_picker.dart';

class FileServices {
  FileServices._privateConstructor();

  static final FileServices _instance = FileServices._privateConstructor();

  static FileServices get instance => _instance;

  Future<XFile?> takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image;
    }
    return null;
  }
}
