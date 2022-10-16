import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiokey/constants.dart';
import 'package:hiokey/controllers/dashnoard_controller.dart';
import 'package:image_picker/image_picker.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  final dashboardController = Get.put(DashboardController());
  TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              children: const [
                SizedBox(width: 20),
                Text("Ask your Query",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ],
            ),
            const SizedBox(height: defaultPadding),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: TextField(
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
                  hintText: 'Type your question here',
                  // errorText: physicianLoginController.emailErrorText.value == 'null' ? null : physicianLoginController.emailErrorText.value,
                ),
                onTap: (){
                  // addVisitDetailsController.resetDosageUnit();
                },
                onChanged: (text){
                  // addVisitDetailsController.resetDosageUnit();
                  // addVisitDetailsController.setDosageUnit(true, text);
                },
              ),
            ),
            const SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: Row(
                children: const[
                  Text("Attach an Image",style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                  ),
                  iconSize: 50,
                  color: paletteOne,
                  splashColor: Colors.grey,
                  onPressed: () async {
                    var source = ImageSource.camera;
                    XFile image = await dashboardController.imagePicker.pickImage(
                        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                    await dashboardController.setQuestionPicture(image.path);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.image_outlined,
                  ),
                  iconSize: 50,
                  color: paletteOne,
                  splashColor: Colors.grey,
                  onPressed: () async {
                    var source = ImageSource.gallery;
                    XFile image = await dashboardController.imagePicker.pickImage(
                        source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                    await dashboardController.setQuestionPicture(image.path);
                  },
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: Row(
                children: [
                  const Text("Ask Anonymously ?",style: TextStyle(fontWeight: FontWeight.bold),),
                  Obx(() =>
                  Switch(
                    // This bool value toggles the switch.
                    value: dashboardController.is_anonymous.value,
                    activeColor: paletteOne,
                    onChanged: (bool value) {
                      dashboardController.is_anonymous.value = !dashboardController.is_anonymous.value;
                    },
                  ))
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            Obx(() => dashboardController.isLoading.value ? const CircularProgressIndicator():ElevatedButton(onPressed: () async{
              // if(patientProfileController.phoneErrorText == 'null' && patientProfileController.nameErrorText == 'null'){
              //   _showLoading(context);
              FocusManager.instance.primaryFocus?.unfocus();
              var query_string = queryController.value.text;
              var response = await dashboardController.sendQuestion(query_string);
                if(response["success"]){
                  queryController.clear();
                  dashboardController.is_anonymous.value = false;
                  dashboardController.question_picture.value = 'null';
                }else{
                  Get.snackbar(
                    "Error",
                    "Cannot Submit Query",
                    icon: const Icon(Icons.error_outline_outlined, color: Colors.white),
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.redAccent,
                  );
                }
            }, child: const Text("Send Question",style: TextStyle(fontSize: 12),),
                style: ElevatedButton.styleFrom(shape: StadiumBorder(),fixedSize: Size(150, 45))
            )),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }
}
