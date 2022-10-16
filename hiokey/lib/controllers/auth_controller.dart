import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hiokey/services/auth_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthController extends GetxController{

  final box = GetStorage();
  final isLoading = false.obs;
  final numberErrorText = "null".obs;
  bool get isAuthenticated => box.read('is_authenticated') ?? false;

  Future<bool> saveAuthToken(String? token) async {
    final box = GetStorage();
    await box.write('auth_token', token);
    return true;
  }

  String? getAuthToken() {
    final box = GetStorage();
    return box.read('auth_token');
  }

  loginPatient(phone,name) async{
    isLoading.value = true;
    var response = await loginPatientService(phone, name);
    try{
      if(response["success"]){
        await box.write('is_authenticated', true);
        await saveAuthToken(response["auth_token"]);
        print(response["patient"]);
        OneSignal.shared.setExternalUserId(response["patient"]["user_id"]).then((results) {
          print(results.toString());
        }).catchError((error) {
          print(error.toString());
        });
      }
      isLoading.value = false;
      return response;
    }catch(e){
      isLoading.value = false;
      return response;
    }
  }

}