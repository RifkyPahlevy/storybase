import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  RxBool isHidden = false.obs;
  RxBool isLoading = false.obs;
  RxBool isPictExist = true.obs;
  XFile? image;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> profileData =
          await firestore.collection("users").doc(auth.currentUser!.uid).get();
      isPictExist.value = true;
      return profileData.data();
    } catch (e) {
      print(e);
    }
    return null;
  }

  void pictImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);
    update();
  }

  void updateProfile() async {
    if (namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        phoneC.text.isNotEmpty) {
      String uid = await auth.currentUser!.uid;
      try {
        isLoading.value = true;
        await firestore.collection("users").doc(uid).update({
          "nama": namaC.text,
          "phone": phoneC.text,
        });

        if (image != null) {
          String ext = image!.name.split(".").last;
          await storage
              .ref(uid)
              .child("profile.$ext")
              .putFile(File(image!.path));

          String url =
              await storage.ref(uid).child("profile.$ext").getDownloadURL();

          await firestore
              .collection("users")
              .doc(auth.currentUser!.uid)
              .update({"image": url});
        }

        if (passC.text.isNotEmpty) {
          if (passC.text.length >= 6) {
            await auth.currentUser!.updatePassword(passC.text);
            auth.signOut();
            Get.offAllNamed(Routes.LOGIN);
            isLoading.value = false;
          } else {
            Get.snackbar("Terjadi Kesalahan", "Password minimal 6 karakter");
            isLoading.value = false;
          }
        }
        isLoading.value = false;
        Get.back();
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Data tidak boleh kosong",
      );
    }
  }

  void logout() async {
    try {
      await auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Gagal Logout");
    }
  }

  void resetPict() {
    if (image != null) {
      image = null;
      update();
    }
  }

  void clearImage() {
    String uid = auth.currentUser!.uid;
    firestore
        .collection("users")
        .doc(uid)
        .update({"image": FieldValue.delete()});
    isPictExist.value = false;
    update();
  }
}
