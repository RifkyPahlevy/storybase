import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_story_controller.dart';

class AddStoryView extends GetView<AddStoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddStoryView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          GetBuilder<AddStoryController>(
            builder: (c) {
              return controller.image != null
                  ? Container(
                      height: Get.height * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: FileImage(File(c.image!.path)),
                              fit: BoxFit.cover)),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: Get.height * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        ElevatedButton(
                            onPressed: () => controller.pictImage(),
                            child: Text("Add photo"))
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
                  controller.addStory();
                }
              },
              child: Obx(() =>
                  Text(controller.isLoading.isFalse ? "Tambah" : "Loading..")))
        ],
      ),
    );
  }
}
