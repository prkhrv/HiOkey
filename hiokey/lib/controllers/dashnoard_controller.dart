import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiokey/services/query_service.dart';
import 'package:image_picker/image_picker.dart';

class DashboardController extends GetxController{
  @override
  void onInit() {
    imagePicker = ImagePicker();
    super.onInit();
  }
  final is_anonymous = false.obs;
  var _image;
  var imagePicker;
  final question_picture = 'null'.obs;
  final isLoading = false.obs;

  setQuestionPicture(filePath){
    question_picture.value = filePath;
  }

  sendQuestion(query_string) async{
    isLoading.value = true;
    var data = {
      "question":query_string,
      "is_anonymous":is_anonymous.value.toString()
    };
    var response = await addQuestionService(data,question_picture.value);
    print(response);
    try{
      if(response["success"]){
        Get.snackbar(
          "Success",
          "Query Submitted Successfully",
          icon: const Icon(Icons.error_outline_outlined, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
        );
      }
      isLoading.value = false;
      return response;
    }catch(e){
      isLoading.value = false;
      return response;
    }
  }
}