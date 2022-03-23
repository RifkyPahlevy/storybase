import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  RxBool isRemember = false.obs;
  final box = GetStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        UserCredential userCredit = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);
        if (userCredit.user!.emailVerified == true) {
          if (isRemember.isTrue) {
            if (box.read("remember") != null) {
              box.remove("remember");
            }
            box.write("remember", {"email": emailC.text, "pass": passC.text});
          }
          isLoading.value = false;
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.defaultDialog(
              middleText: "Apakah anda ingin dikirimkan email verifikasi lagi?",
              title: "Email Verifikasi",
              actions: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("Tidak")),
                OutlinedButton(
                    onPressed: () {
                      userCredit.user!.sendEmailVerification();
                      Get.back();
                    },
                    child: Text("Ya")),
              ]);
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Email atau Password salah");

        print(e);
      }
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "Email dan Password tidak boleh kosong");
    }
  }
}
