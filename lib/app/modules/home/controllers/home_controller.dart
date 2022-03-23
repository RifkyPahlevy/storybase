import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<DocumentSnapshot<Map<String, dynamic>>> StreamGetProfile() async* {
    try {
      yield* await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllStories() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore
        .collection("users")
        .doc(uid)
        .collection("story")
        .snapshots();
  }

  void deleteStory(String id) {
    try {
      String uid = auth.currentUser!.uid;
      firestore
          .collection("users")
          .doc(uid)
          .collection("story")
          .doc(id)
          .delete();
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Gagal menghapus cerita");
    }
  }
}
