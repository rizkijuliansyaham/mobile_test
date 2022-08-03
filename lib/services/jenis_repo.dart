import 'dart:convert';

import 'package:test_qtasnim/models/data_error.dart';
import 'package:test_qtasnim/models/jenis.dart';
import 'package:test_qtasnim/utils/url_data.dart';
import 'package:http/http.dart' as http;

class JenisRepo {
  Future<List<JenisModel>> getJenis() async {
    const requestUrl = '${DataUrl.baseUrl}Jenis';

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
            return JenisModel.fromJson(e);
          },
        ).toList();
      } else {
        throw Exception('Failed to load Transaksi');
      }
    } catch (e) {
      throw DataError(message: e.toString());
    }
  }

  static Future<dynamic> addJenis(int id_jenis, String jenis_barang) async {
    String apiURL = '${DataUrl.baseUrl}Jenis/create';

    Map<String, String> header = {
      'Content-type': 'application/json',
    };
    var body = jsonEncode({'id_jenis': id_jenis, 'jenis_barang': jenis_barang});

    var apiResult = await http.post(
      Uri.parse(apiURL),
      body: body,
      headers: header,
    );

    var jsonObject = json.decode(apiResult.body);

    return jsonObject;
  }
}
