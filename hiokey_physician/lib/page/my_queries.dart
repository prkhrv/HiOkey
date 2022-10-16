import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hiokey_physician/constants.dart';
import 'package:hiokey_physician/controllers/query_controller.dart';



class MyQueries extends StatelessWidget {
  MyQueries({Key? key}) : super(key: key);
  final queryController = Get.put(QueryController());

  @override
  Widget build(BuildContext context) {
    queryController.fetchQuestions();
    return Scaffold(
      body: GestureDetector(
        onTap: () => {FocusManager.instance.primaryFocus?.unfocus()},
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const[
                SizedBox(width: 20),
                Text("Previous Queries",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
              ],
            ),
            const SizedBox(height: defaultPadding),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.90,
              child: TextField(
                  keyboardType: TextInputType.text,
                  // controller: _nameController,
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
                    hintText: 'Search For Queries',
                    // errorText: prescriptionsController.searchError.value == 'null' ? null : prescriptionsController.searchError.value
                  ),
                  onChanged: (text) async{
                    // var res = await prescriptionsController.validateSearch(text);
                    // if(res){
                    //   await prescriptionsController.searchBarPrescriptions(text);
                    // }
                  }
              ),
            ),
            const SizedBox(height: defaultPadding*2),
            Expanded(child:Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                  )
                ],
              ),
              child: NotificationListener(
                onNotification: (scrollNotification){
                  if (scrollNotification is ScrollStartNotification) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: queryController.controller,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      queryController.isSearchingQueries.value ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(child: CircularProgressIndicator())) : _buildPrescriptions(context, queryController.queries),
                      queryController.isNextPageLoading.value ? CircularProgressIndicator() : const SizedBox(height: 0),
                      const SizedBox(height: 10)
                    ],
                  )),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptions(BuildContext context,prescriptions){
    return prescriptions.length > 0 ? SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: GetBuilder(
        init: queryController,
        builder: (value) => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: prescriptions.length,
            itemBuilder: (context,index){
              return Container(
                child: Card(
                  margin: EdgeInsets.only(bottom: 30),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10))
                        ),
                        height: 50,
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            Flexible(child: Text("${prescriptions[index]["question"]}",overflow: TextOverflow.clip,style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Color(0xff4d368f))))
                          ],
                        ),
                      ),
                      ExpandablePanel(
                          theme: ExpandableThemeData(),
                          header: Column(
                            children: [
                              const SizedBox(height: 15),
                              Row(
                                children:  [
                                  const SizedBox(width: 20),
                                  prescriptions[index]["answer"] != null ? Text("Tap to see The answer",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)):
                                  Text("This question has NOT been answered yet",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.red))
                                ],
                              ),
                            ],
                          ),
                          collapsed: Container(),
                          expanded: prescriptions[index]["answer"] == null ? Container():Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text("My Response :",style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: defaultPadding),
                                Text("${prescriptions[index]["answer"]}"),
                                const SizedBox(height: defaultPadding),
                                Text("Patient Rating :",style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                RatingBarIndicator(
                                  rating: prescriptions[index]["rating"].toDouble(),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 25.0,
                                  direction: Axis.horizontal,
                                ),
                                const SizedBox(height: defaultPadding)
                              ],
                            ),
                          )
                      ),


                    ],
                  ),
                ),
              );
            }
        ),
      ) ,
    ) : const Text("No Queries Available",style: TextStyle(fontWeight:FontWeight.bold, color: Colors.red));
  }
}
