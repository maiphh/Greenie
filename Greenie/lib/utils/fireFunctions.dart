import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Upload image to Cloud Storage via image path [path]
Future uploadImage(String path) async {

    if (path == "") return;
    final imageTemp = File(path);
    final storageRef = FirebaseStorage.instance.ref();
    final avatarRef = storageRef.child(path);
    try {
      await avatarRef.putFile(imageTemp, SettableMetadata(
        contentType: "image/jpeg",
      ));
    }
    on Exception catch (e) {
      print("Something wrong");
    }

}

Future<String> getImageUrl(String imageRef) async {
  String result;

  final storageRef = FirebaseStorage.instance.ref();
  final ref = storageRef.child(imageRef);
  final url = await ref.getDownloadURL();
  return url;
  // return (result);
}