import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiokey_physician/constants.dart';
import 'package:hiokey_physician/services/query_service.dart';

class DashboardController extends GetxController{

  @override
  void onInit() {
    fetchQuestions();
    super.onInit();
  }
  final isLoading = false.obs;
  List<Container> cards = [];
  var questions = [];
  final answerErrorText = "null".obs;
  final showNoCardsLeft = false.obs;

  // List<Container> cards = [
  //   Container(
  //     alignment: Alignment.center,
  //     child: const Text('1'),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       color: paletteTwo
  //     ),
  //   ),
  //   Container(
  //     alignment: Alignment.center,
  //     child: const Text('2'),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(15),
  //         color: paletteThree
  //       )
  //   ),
  //   Container(
  //     alignment: Alignment.center,
  //     child: const Text('Hi I have a issue?'),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(15),
  //         color: paletteFour
  //       )
  //   )
  // ];

  setCards(questions){
    List colors = [paletteTwo,paletteThree,paletteFour];
    Random random = Random();
    for (var i = 0;i<questions.length;i++){
      cards.add(
          Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: colors[random.nextInt(3)]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    questions[i]["q_picture"] != null ?
                    Image.network(questions[i]["q_picture"],height: 400):Container(),
                    const SizedBox(height: defaultPadding),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Text(questions[i]["question"],textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    ),
                  ],
                ),
          )
      );
    }

    if(cards.isEmpty){
      showNoCardsLeft.value = true;
    }
  }

  setQuestions(data){
    questions = List.from(data);
  }


  fetchQuestions() async{
    isLoading.value = true;
    showNoCardsLeft.value = false;
    var response = await fetchQuestionsService();
    if(response["success"]){
      cards.clear();
      setCards(response["questions"]);
      setQuestions(response["questions"]);
      isLoading.value = false;
    }else{
      Get.snackbar(
        "Error",
        "Cannot Fetch Queries",
        icon: const Icon(Icons.error_outline_outlined, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
      );
      isLoading.value = false;
    }
  }

  addAnswer(index,answer) async{
    var question_id = questions[index]["id"];
    var data = {
      "question_id":question_id,
      "answer":answer
    };
    var response = await updateAnswerService(data);
    if(response["success"]){
      return true;
    }else{
      return false;
    }

  }
}