import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProfileView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                controller.logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            controller.namaC.text = snapshot.data!["nama"];
            controller.emailC.text = snapshot.data!["email"];
            controller.phoneC.text = snapshot.data!["phone"];

            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                GetBuilder<ProfileController>(
                  builder: (c) {
                    return Column(
                      children: [
                        controller.image != null
                            ? Column(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                            image: FileImage(
                                                File(controller.image!.path)),
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(height: 10),
                                  TextButton(
                                      onPressed: () => controller.resetPict(),
                                      child: Text("Batal"))
                                ],
                              )
                            : snapshot.data?["image"] != null &&
                                    controller.isPictExist.isTrue
                                ? Column(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    snapshot.data!["image"]),
                                                fit: BoxFit.cover)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                          onPressed: () =>
                                              controller.clearImage(),
                                          child: Text("Hapus Foto"))
                                    ],
                                  )
                                : Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://ui-avatars.com/api/?name=${snapshot.data!["nama"]}"),
                                            fit: BoxFit.cover))),
                        TextButton(
                            onPressed: () {
                              controller.pictImage();
                            },
                            child: Text("add photo"))
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: controller.namaC,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: controller.phoneC,
                  autocorrect: false,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.updateProfile();
                    }
                  },
                  child: Obx(() => Text(
                      controller.isLoading.isFalse ? "Update" : "Loading..")),
                ),
              ],
            );
          }),
    );
  }
}
