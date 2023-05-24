import 'package:image_picker/image_picker.dart';

class ImgPicker {
  //for image uploading
  final ImagePicker picker = ImagePicker();

  //get image from gallery
  Future<XFile?> getImageFromGallery() async {
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> getImageFromCamera() async {
    return await picker.pickImage(source: ImageSource.camera);
  }
}
