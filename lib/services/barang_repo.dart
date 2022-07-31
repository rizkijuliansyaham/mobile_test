import 'dart:convert';

import 'package:test_qtasnim/models/barang.dart';
import 'package:http/http.dart' as http;

class BarangRepo {
  BarangModel? barangModel;

  Future getDataBarang() async {
    try {
      String apiURL = 'http://192.168.8.101:5000/Barang';

      var apiResult = await http.get(Uri.parse(apiURL));

      if (apiResult.statusCode == 200) {
        /// successfully get data
        var jsonObject = json.decode(apiResult.body);
        barangModel = BarangModel.fromJson(jsonObject);
      } else {
        /// failure get data
        print(apiResult.statusCode);
      }
    } catch (error) {
      print(error);
    }
  }
}