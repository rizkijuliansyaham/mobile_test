import 'dart:convert';

import 'package:test_qtasnim/models/transaksi_model.dart';
import 'package:http/http.dart' as http;

class TransaksiRepo {
  static TransaksiModel? transaksiModel;

  static getDataTransaksi() async {
    try {
      String apiURL = 'http://192.168.8.101:5000/Transaksi';

      var apiResult = await http.get(Uri.parse(apiURL));

      if (apiResult.statusCode == 200) {
        /// successfully get data
        var jsonObject = json.decode(apiResult.body);
        transaksiModel = TransaksiModel.fromJson(jsonObject);
      } else {
        /// failure get data
        print(apiResult.statusCode);
      }
    } catch (error) {
      print(error);
    }
  }
}
