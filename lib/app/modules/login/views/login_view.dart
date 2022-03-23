import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:storyapp/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    if (box.read("remember") != null) {
      controller.emailC.text = box.read("remember")["email"];
      controller.passC.text = box.read("remember")["pass"];
      controller.isRemember.value = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('LoginView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.emailC,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() => TextField(
                controller: controller.passC,
                autocorrect: false,
                keyboardType: TextInputType.text,
                obscureText: controller.isHidden.value,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffix: IconButton(
                        onPressed: () => controller.isHidden.toggle(),
                        icon: Icon(Icons.remove_red_eye_sharp))),
              )),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
                onPressed: () => Get.toNamed(Routes.RESET_PASSWORD),
                child: Text("Forgot Password?")),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.isLoading.isFalse) {
                controller.login();
              }
            },
            child: Obx(() =>
                Text(controller.isLoading.isFalse ? "Login" : "Loading..")),
          ),
          Obx(() => CheckboxListTile(
                value: controller.isRemember.value,
                onChanged: (value) {
                  controller.isRemember.toggle();
                },
                title: Text('Remember me'),
                controlAffinity: ListTileControlAffinity.leading,
              )),
          SizedBox(
            height: 20,
          ),
          Text("Belum Punya Akun ?"),
          TextButton(
              onPressed: () => Get.toNamed(Routes.REGISTER),
              child: Text("Register"))
        ],
      ),
    );
  }
}
