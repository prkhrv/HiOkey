import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiokey_physician/services/query_service.dart';

class QueryController extends GetxController{
  ScrollController controller = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    fetchQuestions();
    super.onInit();
  }

  final isSearchingQueries = false.obs;
  final isNextPageLoading = false.obs;
  List queries = [];
  List temp_queries = [];
  bool hasNext = true;
  int nextPageNumber = 2;

  setQueries(data){
    queries = List.from(data);
  }


  fetchQuestions() async{
    isSearchingQueries.value = true;
    var response = await fetchMyQuestionsService();
    if(response["success"]){
      setQueries(response["questions"]);
      isSearchingQueries.value = false;
    }else{
      Get.snackbar(
        "Error",
        "Cannot Fetch Queries",
        icon: const Icon(Icons.error_outline_outlined, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
      );
      isSearchingQueries.value = false;
    }
  }


}