import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class AppUtils {
  static Future<String?> pickImage(
      ImageSource source, ImagePicker imagePicker) async {
    try {
      final image = await imagePicker.pickImage(source: source);
      if (image == null) {
        return null;
      }

      final imageTemporary = XFile(image.path);

      final bytes = await imageTemporary.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      return null;
    }
  }
}
