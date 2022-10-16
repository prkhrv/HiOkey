import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{
  final showPage = "dashboard".obs;
  GlobalKey<ConvexAppBarState> appBarKey = GlobalKey<ConvexAppBarState>();

  pageSelector(int page){
    if(page == 0){
      showPage.value = "dashboard";
      appBarKey.currentState?.animateTo(page);
    }
    if(page == 1){
      showPage.value = "my_queries";
      appBarKey.currentState?.animateTo(page);
    }
  }
}