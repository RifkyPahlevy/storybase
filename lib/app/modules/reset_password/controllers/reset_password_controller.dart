import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  TextEditingController emailC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  void resetPassword() async {
    if (emailC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        await auth.sendPasswordResetEmail(email: emailC.text);
        isLoading.value = false;
        Get.back();
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email tidak boleh kosong");
    }
  }
}
