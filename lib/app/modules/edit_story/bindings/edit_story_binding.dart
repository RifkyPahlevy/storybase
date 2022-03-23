import 'package:get/get.dart';

import '../controllers/edit_story_controller.dart';

class EditStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditStoryController>(
      () => EditStoryController(),
    );
  }
}
