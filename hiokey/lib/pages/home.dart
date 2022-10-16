import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiokey/constants.dart';
import 'package:hiokey/controllers/home_controller.dart';
import 'package:hiokey/pages/dashboard.dart';
import 'package:hiokey/pages/my_queries.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.put(HomeController());

  var pageObj = {
    "dashboard":Dashboard(),
    "my_queries": MyQueries()
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() =>Scaffold(
      bottomNavigationBar: StyleProvider(
        style: Style(),
        child: ConvexAppBar(
          key: homeController.appBarKey,
          backgroundColor: paletteOne,
          style: TabStyle.reactCircle,
          curveSize: 80,
          initialActiveIndex: 0,
          items: const [
            TabItem(icon: Icons.home_outlined,title: 'Home',),
            TabItem(icon: Icons.chat_outlined, title: 'My Queries')
          ],
          onTap: (i) {
            homeController.pageSelector(i);

          },
        ),
      ),
      body: Container(
        child: pageObj[homeController.showPage.value],
      ),
    ),
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 30;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color,String? fontFamily) {
    return TextStyle(fontSize: 10, color: color);
  }
}