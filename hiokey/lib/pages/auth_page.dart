import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiokey/constants.dart';
import 'package:hiokey/controllers/auth_controller.dart';
import 'package:hiokey/pages/home.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);
  final authController = Get.put(AuthController());
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/1_clean.png',height: 180),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 350,
                      child: Row(
                        children:  const [
                          SizedBox(width: 8),
                          Text("Patient Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: TextField(
                          keyboardType: TextInputType.text,
                          controller: nameController,
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
                            hintText: 'Enter your Name',
                            // errorText: immunizationController.searchError.value == 'null' ? null : immunizationController.searchError.value
                          ),
                          onChanged: (text) async{
                            // var res = await immunizationController.validateSearch(text);
                            // if(res){
                            //   await immunizationController.searchBarImmunizations(text);
                            // }
                          }
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.90,
                      child: Obx(() => IntlPhoneField(
                        controller: numberController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xff4d368f), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black, width: 1.0),
                            ),
                            labelText: 'Phone Number*',
                            errorText: authController.numberErrorText.value == 'null' ? null: authController.numberErrorText.value
                        ),
                        initialCountryCode: 'US',
                        countries: const ['US'],
                        onChanged: (phone) {
                          // loginController.numberErrorText.value  = loginController.phoneValidator();
                        },
                      )),
                    ),
                    const SizedBox(height: 50),
                    Obx(() => authController.isLoading.value ? CircularProgressIndicator() :
                    ElevatedButton.icon(onPressed: () async{
                      var phone = "1"+numberController.value.text;
                      var name = nameController.value.text;
                      var res = await authController.loginPatient(phone,name);
                      if(res["success"] == true){
                        Get.offAll(() => const HomePage());
                      }else{
                        Get.snackbar(
                          "Error",
                          "Cannot Process the Request",
                          icon: Icon(Icons.error_outline_outlined, color: Colors.white),
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.redAccent,
                        );
                      }

                    },
                      icon: const Text("Get Started"),
                      label: const Icon(Icons.arrow_forward_rounded),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: paletteOne,
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular
                            (30.0),
                        ),
                      ) ,
                    ))
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}