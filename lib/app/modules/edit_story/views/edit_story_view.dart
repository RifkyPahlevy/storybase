import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_story_controller.dart';

class EditStoryView extends GetView<EditStoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EditStoryView'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getStory(Get.arguments.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return Center(
                child: Text("No data"),
              );
            }
            controller.judulC.text = snapshot.data!["judul"];
            controller.ceritaC.text = snapshot.data!["cerita"];
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                GetBuilder<EditStoryController>(
                  builder: (c) {
                    return snapshot.data?["urlPict"] != null
                        ? Container(
                            height: Get.height * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image:
                                        NetworkImage(snapshot.data!["urlPict"]),
                                    fit: BoxFit.cover)),
                          )
                        : controller.image != null
                            ? Container(
                                height: Get.height * 0.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: FileImage(
                                            File(controller.image!.path)),
                                        fit: BoxFit.cover)))
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: Get.height * 0.3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  ElevatedButton(
                                      onPressed: () => controller.pictImage(),
                                      child: Text("Edit photo"))
                                ],
                              );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  autocorrect: false,
                  controller: controller.judulC,
                  decoration: InputDecoration(
                    labelText: "judul",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: controller.ceritaC,
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "Cerita anda",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (controller.isLoading.isFalse) {
                        controller.editStory(Get.arguments.toString());
                      }
                    },
                    child: Obx(() => Text(
                        controller.isLoading.isFalse ? "Edit" : "Loading..")))
              ],
            );
          }),
    );
  }
}
