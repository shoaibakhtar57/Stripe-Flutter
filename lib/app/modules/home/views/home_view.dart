import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:stripe_app/app/modules/home/controllers/builderIds.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomeView'),
          centerTitle: true,
        ),
        body: GetBuilder<HomeController>(
          id: kPayment,
          builder: (_) => Container(
            padding: EdgeInsets.all(20.0),
            child: ListTile(
              onTap: () {
                controller.makePayment();
              },
              leading: Icon(Icons.payment),
              title: Text('Pay with new card'),
            ),
          ),
        ));
  }
}
