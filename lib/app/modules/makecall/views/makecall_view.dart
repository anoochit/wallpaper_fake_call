import 'dart:developer';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/makecall_controller.dart';

class MakecallView extends StatefulWidget {
  const MakecallView({Key? key}) : super(key: key);

  @override
  State<MakecallView> createState() => _MakecallViewState();
}

class _MakecallViewState extends State<MakecallView> {
  CameraController? cameraController;
  bool isCameraInitialize = false;
  CameraValue? cameraValue;
  CameraDescription? frontCamera;

  VideoPlayerController? videoController;

  MakecallController controller = Get.find<MakecallController>();

  @override
  void initState() {
    super.initState();
    initVideo();
    isCameraAvailable();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController!.dispose();
    videoController!.dispose();
  }

  initVideo() {
    // init video
    videoController = VideoPlayerController.asset('assets/videos/${controller.currentContact.video}')
      ..initialize().then((_) {
        setState(() {
          // set video loop
          videoController!.setLooping(true);
          log('assets/videos/${controller.currentContact.video}');
          log('ratio : ${videoController!.value.aspectRatio}');
        });
      });
  }

  isCameraAvailable() {
    // check available camera
    availableCameras().then((listCameraDescription) {
      log('camera found = ${listCameraDescription.length}');

      // process only front camera
      for (var camera in listCameraDescription) {
        if (camera.lensDirection.name == "front") {
          // get contoller
          cameraController = CameraController(camera, ResolutionPreset.high);

          // initialized
          cameraController!.initialize().then((_) {
            if (!mounted) {
              return;
            }

            // set camera value
            cameraValue = cameraController!.value;
            frontCamera = camera;

            // start image stream for image processing
            cameraController!.startImageStream((cameraImage) {
              // de face dectection
            }).catchError((error) {
              log('$error');
            });

            // setstate
            // setState(() {
            isCameraInitialize = true;
            // });
          }).catchError((Object e) {
            // show error
            if (e is CameraException) {
              switch (e.code) {
                case 'CameraAccessDenied':
                  log('User denied camera access.');
                  break;
                default:
                  log('Handle other errors.');
                  break;
              }
            }
          });
        }
      }
    });
  }

  playRingtone() {
    if (GetPlatform.isAndroid) {
      FlutterRingtonePlayer.play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.electronic,
        looping: true,
        asAlarm: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MakecallController>(
        builder: (controller) {
          if (!controller.isCalling.value) {
            log("play ring tone");
            playRingtone();
          }
          return Stack(
            children: [
              // background image
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/avatars/${controller.currentContact.avatar}',
                  fit: BoxFit.cover,
                ),
              ),

              // blure
              (!controller.isCalling.value)
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.0),
                        ),
                      ),
                    )
                  : Container(),

              // video
              ((videoController != null) && (controller.isCalling.value))
                  // if calling show video
                  ? Container(
                      color: Colors.black,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: videoController!.value.aspectRatio,
                          child: VideoPlayer(videoController!),
                        ),
                      ),
                    )
                  : Container(),

              // title
              (!controller.isCalling.value)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Incomming call",
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                        ),
                      ),
                    )
                  : Container(),

              // avatar
              (!controller.isCalling.value)
                  ? Center(
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage(
                          'assets/avatars/${controller.currentContact.avatar}',
                        ),
                      ),
                    )
                  : Container(),

              // call and reject button
              (!controller.isCalling.value)
                  // not call
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 128.0),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // accept call
                            InkWell(
                              onTap: () {
                                // stop ring tone
                                FlutterRingtonePlayer.stop();

                                // play video
                                videoController!.play();

                                // set state calling
                                controller.isCalling.value = true;
                                controller.update();
                              },
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.green,
                                child: Icon(
                                  Icons.call,
                                  size: 48.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            // end call
                            InkWell(
                              onTap: () {
                                // stop ring tone
                                FlutterRingtonePlayer.stop();

                                // dispose camera controller
                                if (cameraController != null) {
                                  cameraController!.stopImageStream();
                                  //cameraController!.dispose();
                                }

                                // pause video
                                videoController!.pause();

                                // set state calling and open camera
                                controller.isCalling.value = false;
                                controller.openCamera.value = true;
                                Get.back();
                              },
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.call_end,
                                  size: 48.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  :
                  // in calling
                  Padding(
                      padding: const EdgeInsets.only(bottom: 128.0),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // mic
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.mic,
                                size: 48.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            // end call
                            InkWell(
                              onTap: () {
                                if (cameraController != null) {
                                  cameraController!.stopImageStream();
                                  //cameraController!.dispose();
                                }

                                // pause video
                                videoController!.pause();

                                controller.openCamera.value = true;
                                controller.isCalling.value = false;
                                Get.back();
                              },
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.call_end,
                                  size: 48.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            // show camera
                            InkWell(
                              onTap: () {
                                controller.openCamera.value = !controller.openCamera.value;
                                controller.update();
                              },
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.video_call,
                                  size: 48.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

              // canera preview
              ((controller.openCamera.value == true) && (cameraController != null))
                  ? Positioned(
                      bottom: 128 + 88 + 16,
                      right: 64,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: CameraPreview(cameraController!),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
