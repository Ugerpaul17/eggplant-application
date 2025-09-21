import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
//import 'package:firebase_auth/firebase_auth.dart';

Future<dynamic> sendToPredictor(imagePath) async {
  final imageBytes = File(imagePath).readAsBytesSync();
  String imageBase64 = base64Encode(imageBytes);

  var dio = Dio(BaseOptions(
      connectTimeout: 10000, // 10 seconds in milliseconds
      receiveTimeout: 20000 // 20 seconds in milliseconds
      ));

  /*final response = await dio
      .post("https://plant-disease-detector-pytorch.herokuapp.com/", data: {
    'image': imageBase64,
  }); */
  try {
    final response =
        await dio.post("https://eggplant-application.onrender.com", data: {
      'image': imageBase64,
    });
    return response.data;
  } catch (e) {
    print('Error sending image: $e');
    return null; // or handle the error as needed
  }

  sendAlerts({plant, disease, username}) async {
    //final User user = Authentication.getCurrentUser();
    var dio = Dio();

    /*final response = await dio.post(
      "https://plant-disease-detector-pytorch.herokuapp.com/notification",
      data: {'plant': plant, 'disease': disease, 'user': user.displayName});
*/
    // final String plant = response.data['plant'];
    // final String disease = response.data['disease'];

    // final result = {'plant': plant, 'disease': disease};

    // return response.data;
  }
}
