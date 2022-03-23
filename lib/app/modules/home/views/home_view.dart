import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:storyapp/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.StreamGetProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.data == null) {
                  return CircleAvatar(
                    backgroundColor: Colors.grey[400],
                  );
                }
                var data = snapshot.data!.data();
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.PROFILE),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data?["image"] != null
                        ? data!["image"]
                        : "https://ui-avatars.com/api/?name=${data!["nama"]}"),
                  ),
                );
              })
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.getAllStories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.docs.length == 0) {
              return Center(
                child: Text("No data"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var dataStory = snapshot.data!.docs[index];
                Map<String, dynamic> story = dataStory.data();
                return ListTile(
                  onTap: () =>
                      Get.toNamed(Routes.EDIT_STORY, arguments: dataStory.id),
                  title: Text("${story["judul"]}"),
                  subtitle: Text("${story["cerita"]}"),
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  trailing: IconButton(
                    onPressed: () => controller.deleteStory(dataStory.id),
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_STORY),
        child: Icon(Icons.add),
      ),
    );
  }
}
