import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storyapp/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  RxBool isHidden = false.obs;
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void signUp() async {
    if (emailC.text.isNotEmpty &&
        passC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        phoneC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        UserCredential userCredit = await auth.createUserWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        userCredit.user!.sendEmailVerification();
        Get.snackbar("Email Verifikasi",
            "Kami Telah Mengirimkan Email Verifikasi. Silahkan Cek Email Anda");
        firestore.collection("users").doc(userCredit.user!.uid).set({
          "nama": namaC.text,
          "phone": phoneC.text,
          "email": emailC.text,
          "createAt": DateTime.now().toIso8601String()
        });
        isLoading.value = false;
        Get.toNamed(Routes.LOGIN);
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Email dan Password tidak boleh kosong",
      );
    }
  }
}
