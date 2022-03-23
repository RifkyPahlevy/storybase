import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class AddStoryController extends GetxController {
  TextEditingController judulC = TextEditingController();
  TextEditingController ceritaC = TextEditingController();
  RxBool isLoading = false.obs;
  XFile? image;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  void pictImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);
    update();
  }

  void addStory() async {
    if (judulC.text.isNotEmpty && ceritaC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String uid = auth.currentUser!.uid;
        String? urlPict;
        if (image != null) {
          String ext = image!.name.split(".").last;
          storage.ref(uid).child("imagestory.$ext").putFile(File(image!.path));
          urlPict =
              await storage.ref(uid).child("imagestory.$ext").getDownloadURL();
        }

        await firestore.collection("users").doc(uid).collection("story").add({
          "judul": judulC.text,
          "cerita": ceritaC.text,
          "urlPict": urlPict,
          "createAt": DateTime.now().toIso8601String(),
        });
        isLoading.value = false;
        Get.back();
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "judul dan cerita harus diisi");
    }
  }
}
