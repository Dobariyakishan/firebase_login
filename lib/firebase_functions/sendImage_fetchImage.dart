import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_login/firebase_functions/image_storge_service.dart';
import 'package:flutter/material.dart';

class SendImageFetchImage extends StatefulWidget {
  const SendImageFetchImage({Key? key}) : super(key: key);

  @override
  State<SendImageFetchImage> createState() => _SendImageFetchImageState();
}

class _SendImageFetchImageState extends State<SendImageFetchImage> {
  String filePath = '';
  String fileName = '';

  Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      PlatformFile file = result.files.first;
                      setState(() {
                        print(file.name);
                        print(file.path);
                        filePath = file.path!;
                        fileName = file.name;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No File Selected,')));
                      return;
                    }
                    storage
                        .uploadImage(filePath, fileName)
                        .then((value) => log("file uploaded successfully"))
                        .catchError((error) => log("file failed $error"));
                    log('imagePath : ${fileName}');
                  },
                  child: const Text('Select Image')),
              if (filePath != '')
                Image.file(
                  File(filePath),
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              // Image.file(
              //   File('/storage/emulated/0/Download/test.jpg'),
              // )

              FutureBuilder(
                  future: storage.downloadUrl('IMG-20220727-WA0001.jpg'),
                  builder:(BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      log('url : ${snapshot.data}');
                      return SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Container();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
