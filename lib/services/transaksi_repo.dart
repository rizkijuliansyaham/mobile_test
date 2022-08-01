import 'dart:convert';

import 'package:test_qtasnim/models/data_error.dart';
import 'package:test_qtasnim/models/transaksi_model.dart';
import 'package:http/http.dart' as http;
import 'package:test_qtasnim/utils/url_data.dart';

class TransaksiRepo {
  // static TransaksiModel? transaksiModel;

  Future<List<TransaksiModel>> getTransaksi() async {
    const requestUrl = '${DataUrl.baseUrl}Transaksi';

    try {
      final response = await http.Client().get(Uri.parse(requestUrl));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body); // as Map<String, dynamic>;
        // print(json);
        // final data = TransaksiModel.fromJson(json);
        // print(data);
        final data = json as List<dynamic>;
        print(data);
        return data.map(
          (e) {
            return TransaksiModel.fromJson(e);
          },
        ).toList();
      } else {
        throw Exception('Failed to load Transaksi');
      }
    } catch (e) {
      throw DataError(message: e.toString());
    }
  }

  static getDataTransaksi() async {
    try {
      String apiURL = 'http://192.168.8.100:5000/Transaksi';

      var apiResult = await http.get(Uri.parse(apiURL));

      if (apiResult.statusCode == 200) {
        /// successfully get data
        var jsonObject = json.decode(apiResult.body);
        // transaksiModel = TransaksiModel.fromJson(jsonObject);
      } else {
        /// failure get data
        print(apiResult.statusCode);
      }
    } catch (error) {
      print(error);
    }
  }

  static Future<dynamic> deleteTransaksi(int idTransaksi) async {
    String apiURL = 'http://192.168.8.100:5000/Transaksi/delete/$idTransaksi';

    Map<String, String> header = {
      'Content-type': 'application/json',
    };

    var apiResult = await http.delete(
      Uri.parse(apiURL),
      headers: header,
    );

    var jsonObject = json.decode(apiResult.body);

    return jsonObject;
  }

  static Future<dynamic> addTransaksi(
      int id, String nama_barang, int jumlah_terjual, String tanggal) async {
    String apiURL = 'http://192.168.8.100:5000/Transaksi/create';

    Map<String, String> header = {
      'Content-type': 'application/json',
    };
    var body = jsonEncode({
      'id_transaksi': id,
      'nama_barang': nama_barang,
      'jumlah_terjual': jumlah_terjual,
      'tanggal_transaksi': tanggal
    });

    var apiResult = await http.post(
      Uri.parse(apiURL),
      body: body,
      headers: header,
    );

    var jsonObject = json.decode(apiResult.body);

    return jsonObject;
  }
}
