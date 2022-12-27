import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl({required String url}) async {
  if (!await launchUrl(Uri.parse(url))) {
    Get.snackbar('Error', 'Cannot open url');
  }
}
