import 'package:get/get.dart';

import 'package:storyapp/app/modules/add_story/bindings/add_story_binding.dart';
import 'package:storyapp/app/modules/add_story/views/add_story_view.dart';
import 'package:storyapp/app/modules/edit_story/bindings/edit_story_binding.dart';
import 'package:storyapp/app/modules/edit_story/views/edit_story_view.dart';
import 'package:storyapp/app/modules/home/bindings/home_binding.dart';
import 'package:storyapp/app/modules/home/views/home_view.dart';
import 'package:storyapp/app/modules/login/bindings/login_binding.dart';
import 'package:storyapp/app/modules/login/views/login_view.dart';
import 'package:storyapp/app/modules/profile/bindings/profile_binding.dart';
import 'package:storyapp/app/modules/profile/views/profile_view.dart';
import 'package:storyapp/app/modules/register/bindings/register_binding.dart';
import 'package:storyapp/app/modules/register/views/register_view.dart';
import 'package:storyapp/app/modules/reset_password/bindings/reset_password_binding.dart';
import 'package:storyapp/app/modules/reset_password/views/reset_password_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ADD_STORY,
      page: () => AddStoryView(),
      binding: AddStoryBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_STORY,
      page: () => EditStoryView(),
      binding: EditStoryBinding(),
    ),
  ];
}
