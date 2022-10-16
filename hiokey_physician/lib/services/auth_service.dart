import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

String host_url = globals.host_url;

Future loginPhysicianService(phone,name) async{
  try{
    var data = {"phone":phone,"name":name};
    final response = await http.post(Uri.parse('${host_url}/api/physician/auth'),body:data);
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