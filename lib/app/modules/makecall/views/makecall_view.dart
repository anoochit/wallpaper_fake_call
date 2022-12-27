import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/makecall_controller.dart';

class MakecallView extends GetView<MakecallController> {
  const MakecallView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MakecallView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MakecallView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
