import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {

  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> uploadImage (
  String filePath,
  String fileName)async {
   File file =File(filePath);
   try{
     await storage.ref('image/$fileName').putFile(file);
   } on firebase_core.FirebaseException catch(e){
     print('erorr : $e');
   }
  }

  Future<String> downloadUrl (String imageName)async{
    String downloadUrl = await storage.ref('image/$imageName').getDownloadURL();
    return downloadUrl;
  }
}