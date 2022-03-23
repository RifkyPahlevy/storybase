import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:storyapp/app/modules/screenview/Screen.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth auth = FirebaseAuth.instance;
  runApp(
    StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ScreenView();
          }
          print(snapshot.data);
          return GetMaterialApp(
            title: "Application",
            initialRoute: snapshot.data == null ? Routes.LOGIN : Routes.HOME,
            getPages: AppPages.routes,
          );
        }),
  );
}
