import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiokey_physician/constants.dart';
import 'package:hiokey_physician/controllers/dashboardController.dart';
import 'package:image_picker/image_picker.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    dashboardController.fetchQuestions();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.arrow_back_sharp,color: paletteOne),
                Text("Swipe Left to Skip",style: TextStyle(color: paletteOne),),
                // Image.asset('assets/1_clean.png',height: 50),
                Text("Swipe Right to Answer",style: TextStyle(color: paletteOne),),
                Icon(Icons.arrow_forward,color: paletteOne),
              ],
            ),

            Obx(() => dashboardController.isLoading.value ? Container(height: MediaQuery.of(context).size.height-180,child: Center(child: CircularProgressIndicator())):
            Container(
              height: MediaQuery.of(context).size.height-180,
              child: Obx(() => dashboardController.showNoCardsLeft.value ? _showText(context):
              AppinioSwiper(
                cards: dashboardController.cards,
                onSwipe: (int index,AppinioSwiperDirection direction){
                  if(direction.name == "right"){
                    addAnswerPopup(context, index);
                  }
                },
                onEnd: (){
                  dashboardController.showNoCardsLeft.value = true;
                },
              ))
            ))
          ],
        ),
      ),
    );
  }

  addAnswerPopup(BuildContext context,index){
    TextEditingController queryController = TextEditingController();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return Center(
            child: AlertDialog(
              title: Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: const [
                  Text("Add an answer",style: TextStyle(fontSize: 20,color: Color(0xff4d368f),fontWeight: FontWeight.bold),),
                ],),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Text("Question",style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    children:  [
                      Flexible(child: Text("${dashboardController.questions[index]["question"]}",overflow: TextOverflow.clip,style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Obx(() => TextField(
                      maxLines: 6,
                      keyboardType: TextInputType.text,
                      controller: queryController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color(0xff4d368f), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        hintText: 'Type your answer here',
                        errorText: dashboardController.answerErrorText.value == 'null' ? null : dashboardController.answerErrorText.value,
                      ),
                      onTap: (){
                        // addVisitDetailsController.resetDosageUnit();
                      },
                      onChanged: (text){
                        // addVisitDetailsController.resetDosageUnit();
                        // addVisitDetailsController.setDosageUnit(true, text);
                      },
                    )),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(onPressed:() async {
                          var answer = queryController.value.text;

                          if(answer.length < 10){
                            dashboardController.answerErrorText.value = "Please provide a brief answer";
                          }else{
                            _showLoading(context);
                            dashboardController.answerErrorText.value = "null";
                            var resp = await dashboardController.addAnswer(index, answer);
                            if(resp == true){
                              queryController.clear();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Get.snackbar("Success","Successfully Answered the Question",
                                    icon: Icon(Icons.offline_pin_outlined, color: Colors.white),
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.green,
                                  );
                            }else{
                              queryController.clear();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Get.snackbar(
                                "Error",
                                "Cannot Fetch Queries",
                                icon: const Icon(Icons.error_outline_outlined, color: Colors.white),
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.redAccent,
                              );
                            }
                          }
                          // var lab_test_picture = labResultsController.lab_test_picture.value;
                          // if(lab_test_picture == 'null'){
                          //   Navigator.of(context).pop();
                          // }else{
                          //   _showLoading(context);
                          //   var result = await labResultsController.addImageToLabTest(test_id);
                          //   if(result == true){
                          //     Navigator.of(context).pop();
                          //     Navigator.of(context).pop();
                          //     labResultsController.fetchLabResults();
                          //     Get.snackbar("Success","Successfully Added Image to Lab Result",
                          //       icon: Icon(Icons.offline_pin_outlined, color: Colors.white),
                          //       snackPosition: SnackPosition.TOP,
                          //       backgroundColor: Colors.green,
                          //     );
                          //   }else{
                          //     Navigator.of(context).pop();
                          //     labResultsController.resetData();
                          //     Navigator.of(context).pop();
                          //   }
                          // }
                        },
                            child: Text("Confirm",style: TextStyle(fontSize: 15,color: Colors.white)),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                )
                            )
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(onPressed:(){
                          // labResultsController.resetData();
                          dashboardController.answerErrorText.value = "null";
                          Navigator.of(context).pop();
                        },
                            child: Text("Cancel",style: TextStyle(fontSize: 15,color: Color(0xff4d368f))),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: BorderSide(color: Color(0xff4d368f))

                                    )
                                )
                            )
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );

  }

  _showLoading(BuildContext context){
    return showDialog(
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      context: context,
    );
  }

  _showText(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.sync,size: 40,color: paletteOne,),
        Text("No Queries to Answer",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18),)
      ],
    );
  }


}
