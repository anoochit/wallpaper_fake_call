import 'package:get/get.dart';

import '../../../data/models/contact.dart';

class MakecallController extends GetxController {
// make call
  late Contact currentContact;
  Rx<bool> isCalling = false.obs;
  Rx<bool> openCamera = true.obs;
}
