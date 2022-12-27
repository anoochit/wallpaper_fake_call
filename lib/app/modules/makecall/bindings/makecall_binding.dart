import 'package:get/get.dart';

import '../controllers/makecall_controller.dart';

class MakecallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MakecallController>(
      () => MakecallController(),
    );
  }
}
