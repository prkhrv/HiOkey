import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:hiokey/controllers/auth_controller.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

String host_url = globals.host_url;
final AuthController authController = Get.put(AuthController());

Future addQuestionService(data,profile_file_path) async{
  var auth_token = await authController.getAuthToken();
  try{
    print(data);
    if(profile_file_path != 'null'){
      var imgFile = File(profile_file_path);
      var fileType = lookupMimeType(profile_file_path);
      List<int> fileInByte = imgFile.readAsBytesSync();
      String fileInBase64 = "data:${fileType};base64,"+base64Encode(fileInByte);
      data["img"] = fileInBase64;
    }else{
      data["img"] = 'null';
    }
    if(auth_token != null){
      final response = await http.post(Uri.parse('${host_url}/api/add/question'),headers:{"auth-token":auth_token},body:data);
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
  }catch(e){
    print(e);
    return {'error':true};
  }

}

Future fetchQuestionsService() async{
  var auth_token = await authController.getAuthToken();
  if(auth_token != null){
    final response = await http.post(Uri.parse('${host_url}/api/my/questions'),headers:{"auth-token":auth_token});
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

Future updateRatingService(data) async{
  var auth_token = await authController.getAuthToken();
  if(auth_token != null){
    final response = await http.post(Uri.parse('${host_url}/api/update/rating'),headers:{"auth-token":auth_token},body: data);
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