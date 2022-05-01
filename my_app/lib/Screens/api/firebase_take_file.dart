import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
//import 'package:path_provider/path_provider.dart';

class FirebaseFile {
  final Reference ref;
  final String name;
  final String url;

  const FirebaseFile({
    required this.ref,
    required this.name,
    required this.url,
  });
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<void> deleteImage(String imageFileUrl, int nbPhoto) async {
    for (int i = 0; i != nbPhoto; i++)
      FirebaseStorage.instance
          .refFromURL("gs://flutter3-fe413.appspot.com/" + imageFileUrl)
          .delete();
  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);

    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  // static Future<Lisr<FirebaseFile>> deleteAll(String path) async {
  //   final ref = FirebaseStorage.instance.ref(path);

  //   final results = await ref.listAll();
  //   final urls = await
  // }

  // static Future downloadFile(Reference ref) async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/${ref.name}');

  //   await ref.writeToFile(file);
  // }
}
