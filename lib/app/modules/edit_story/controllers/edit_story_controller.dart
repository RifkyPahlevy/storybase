import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class EditStoryController extends GetxController {
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

  Future<Map<String, dynamic>?> getStory(String id) async {
    try {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> dataStory = await firestore
          .collection("users")
          .doc(uid)
          .collection("story")
          .doc(id)
          .get();
      return dataStory.data();
    } catch (e) {
      print(e);
      return null;
    }
  }

  void editStory(String id) async {
    if (judulC.text.isNotEmpty && ceritaC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String uid = auth.currentUser!.uid;
        firestore
            .collection("users")
            .doc(uid)
            .collection("story")
            .doc(id)
            .update({
          "judul": judulC.text,
          "cerita": ceritaC.text,
        });
        print(image!.name);
        if (image != null) {
          String ext = image!.name.split(".").last;

          storage
              .ref(uid)
              .child("pictStoryEdit.$ext")
              .putFile(File(image!.path));
          String imageUrl =
              await storage.ref(uid).child("pictStory.$ext").getDownloadURL();
          firestore
              .collection("users")
              .doc(uid)
              .collection("story")
              .doc(id)
              .update({
            "urlPict": imageUrl,
          });
          isLoading.value = false;
          Get.back();
        }
        isLoading.value = false;
        Get.back();
      } catch (e) {
        isLoading.value = false;

        print(e);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "judul dan cerita harus diisi");
    }
  }
}
