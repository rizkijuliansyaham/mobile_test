// import '../models/transaksi.dart';
// import 'package:http/http.dart' as http;

// class TransaksiRepo {
//   static const String _baseUrl = 'http://localhost:5000/';

//   Future<List<Transaksi>> getTransaksi() async {
//     const requestUrl = '${_baseUrl}Tansaksi';

//     try {
//        final response = await http.Client().get(Uri.parse(requestUrl));
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body) as Map<String, dynamic>;
//         final data = json['Data'] as List<dynamic>;
//         print(data);
//         return data.map((e) {
//           return Transaksi.fromMap(e);
//         }).toList();
//     } catch (e) {
//       throw DataError(message: e.toString());
//     }
//   }
// }
// }