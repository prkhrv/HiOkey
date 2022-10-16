import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hiokey_physician/services/auth_service.dart';

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

  loginPhysician(phone,name) async{
    isLoading.value = true;
    var response = await loginPhysicianService(phone,name);
    try{
      if(response["success"]){
        await box.write('is_authenticated', true);
        await saveAuthToken(response["auth_token"]);
      }
      isLoading.value = false;
      return response;
    }catch(e){
      isLoading.value = false;
      return response;
    }
  }

}