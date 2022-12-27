import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaper_fake_call/app/data/config/contact.dart';
import 'package:wallpaper_fake_call/app/modules/makecall/controllers/makecall_controller.dart';
import 'package:wallpaper_fake_call/app/widgets/banner.dart';

import '../../../routes/app_pages.dart';
import '../controllers/videocall_controller.dart';

class VideocallView extends GetView<VideocallController> {
  const VideocallView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Video Call'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // title
            const SizedBox(
              height: 16.0,
            ),
            Text(
              "Choose name call",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 16.0,
            ),

            // contact list
            const ContactWidget(),
            const SizedBox(
              height: 32.0,
            ),

            // ads
            const BannerAdsWidget(type: AdSize.mediumRectangle),
          ],
        ));
  }
}

class ContactWidget extends StatefulWidget {
  const ContactWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  int pageNo = 0;
  int offset = 0;
  int contactLenght = 0;

  MakecallController makecallController = Get.find<MakecallController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // contact
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: ((MediaQuery.of(context).size.width / 3)) + 16,
          child: PageView.builder(
            itemCount: (contactList.length / 3).ceil(),
            scrollDirection: Axis.horizontal,
            onPageChanged: (value) {
              log('page $value');
              setState(() {
                pageNo = value;
              });
            },
            itemBuilder: (context, index) {
              offset = pageNo * 3;
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width / 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Builder(
                        builder: (context) {
                          if (contactList.length > (offset + i)) {
                            return Column(
                              children: [
                                // avatar
                                InkWell(
                                  onTap: () {
                                    // make a call
                                    makecallController.currentContact = contactList[offset + i];
                                    Get.toNamed(Routes.MAKECALL);
                                  },
                                  child: CircleAvatar(
                                    radius: ((MediaQuery.of(context).size.width / 3) / 2) - 8,
                                    backgroundImage: AssetImage('assets/avatars/${contactList[offset + i].avatar}'),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                // text
                                Text(
                                  contactList[offset + i].name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            );
                          } else {
                            return Container(
                              width: (MediaQuery.of(context).size.width / 3),
                            );
                          }
                        },
                      )
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),

        // page indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate((contactList.length / 3).ceil(), (index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                backgroundColor: (pageNo == index) ? Colors.blue : Colors.grey,
                radius: 8,
              ),
            );
          }),
        )
      ],
    );
  }
}
