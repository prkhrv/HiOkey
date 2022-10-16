import 'dart:convert';
import 'package:get/get.dart';
import 'package:hiokey_physician/controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

String host_url = globals.host_url;
final AuthController authController = Get.put(AuthController());

Future fetchQuestionsService() async{
  try{
    final response = await http.get(Uri.parse('${host_url}/api/fetch/unanswered/questions'));
    final result = jsonDecode(response.body);
    if (response.statusCode == 200){
      if(result["success"] == true){
        //save otp_token
        return result;
      }else{
        return result;
      }
    }else{
      return result;
    }
  }catch(e){
    print(e);
    return {'error':true};
  }
}

Future updateAnswerService(data) async{
  var auth_token = await authController.getAuthToken();
  if(auth_token != null){
    final response = await http.post(Uri.parse('${host_url}/api/update/answer'),headers:{"auth-token":auth_token},body: data);
    final result = jsonDecode(response.body);
    if (response.statusCode == 200){
      if(result["success"] == true){
        //save token
        return result;
      }else{
        return result;
      }
    }else{
      return result;
    }
  }else{
    return{"error":true,"success":false,"auth":false,"message":"Invalid Token"};
  }

}

Future fetchMyQuestionsService() async{
  var auth_token = await authController.getAuthToken();
  if(auth_token != null){
    final response = await http.post(Uri.parse('${host_url}/api/physician/questions'),headers:{"auth-token":auth_token});
    final result = jsonDecode(response.body);
    if (response.statusCode == 200){
      if(result["success"] == true){
        //save token
        return result;
      }else{
        return result;
      }
    }else{
      return result;
    }
  }else{
    return{"error":true,"success":false,"auth":false,"message":"Invalid Token"};
  }

}

