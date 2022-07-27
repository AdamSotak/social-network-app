import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:social_network/auth/auth.dart';
import 'package:social_network/styling/variables.dart';

class VideoStorage {
  // Upload Post video
  Future<String> uploadPostVideo(String videoPath) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse('${Variables.azureStorageURL}/videos/upload'));
      request.fields['userToken'] = await Auth().getUserIDToken();
      request.files.add(
        await http.MultipartFile.fromPath('file', videoPath, contentType: MediaType("video", "mp4")),
      );

      var response = await request.send();
      var responseData = jsonDecode(await response.stream.bytesToString());
      if (responseData["tokenValid"] == false) {
        Auth().logout();
      }
      return responseData["url"];
    } catch (error) {
      log(error.toString());
      return "";
    }
  }

  // Delete Post video
  Future<bool> deletePostVideo(String url) async {
    try {
      var response = await http.delete(
        Uri.parse('${Variables.azureStorageURL}/videos/delete'),
        body: jsonEncode(
          <String, String>{
            'url': url,
            'userToken': await Auth().getUserIDToken(),
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var responseData = jsonDecode(response.body);
      if (responseData["tokenValid"] == false) {
        Auth().logout();
      }
      return true;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}
