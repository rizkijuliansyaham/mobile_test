import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:test_qtasnim/models/transaksi_model.dart';
import 'package:test_qtasnim/pages/barang_page.dart';
import 'package:test_qtasnim/services/barang_repo.dart';
import 'package:test_qtasnim/services/transaksi_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:test_qtasnim/widgets/transaksi_card.dart';
import 'package:test_qtasnim/widgets/transaksi_dialog.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  late Future<List<TransaksiModel>> _getTransaksi;
  // List dataTransaksi = [];
  final _formKey = GlobalKey<FormState>();
  // late StreamController dataTransaksi;
  // late StreamController dataBarang;
  List namaBarang = [];

  bool isDataLoading = false;
  int idTerakhir = 0;
  Timer? _timer;

  @override
  void initState() {
    _getTransaksi = TransaksiRepo().getTransaksi();
    // print(_getTransaksi);
    // DateTime currentDate = DateTime.now();
    // dataTransaksi = new StreamController();
    // dataBarang = new StreamController();
    // _timer = Timer.periodic(Duration(milliseconds: 300), (_) {
    //   // loadDataTransaksi();
    //   // loadDataBarang();
    // });
    super.initState();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  // Future fetchDataTransaksi() async {
  //   try {
  //     isDataLoading = true;
  //     final response =
  //         await http.get(Uri.tryParse('http://192.168.8.100:5000/Transaksi')!);
  //     if (response.statusCode == 200) {
  //       // print(response.body);
  //       return json.decode(response.body);
  //       // final response = await TransaksiRepo.getDataTransaksi();
  //       // print(response);
  //     } else {
  //       print(response.statusCode);
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     isDataLoading = false;
  //   }
  //   // await TransaksiRepo.getDataTransaksi();
  //   // dataTransaksi.addAll(TransaksiRepo.transaksiModel!.);
  // }

  // loadDataTransaksi() async {
  //   fetchDataTransaksi().then((res) async {
  //     dataTransaksi.add(res);
  //     return res;
  //   });
  // }

  // Future fetchDataBarang() async {
  //   try {
  //     isDataLoading = true;
  //     final response =
  //         await http.get(Uri.tryParse('http://192.168.8.100:5000/Barang')!);
  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       return json.decode(response.body);
  //       // final response = await TransaksiRepo.getDataTransaksi();
  //       // print(response);
  //     } else {
  //       print(response.statusCode);
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     isDataLoading = false;
  //   }
  // }

  // loadDataBarang() async {
  //   fetchDataBarang().then((res) async {
  //     dataBarang.add(res);
  //     return res;
  //   });
  // }

  void deleteDataTransaksi(int id) async {
    var delete = await TransaksiRepo.deleteTransaksi(id);
  }

  Future<void> showDialogDelete(
      BuildContext context, String pesan, int id) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(pesan,
                    style: TextStyle(
                        color: BaseTheme.color, fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              InkWell(
                onTap: (() {
                  Navigator.of(context).pop();
                }),
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: BaseTheme.color, width: 0.4)),
                  child: Center(
                    child: Text(
                      "Tidak",
                      style: TextStyle(
                          color: BaseTheme.color, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (() {
                  deleteDataTransaksi(id);
                  Navigator.of(context).pop();
                }),
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: BaseTheme.color,
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: Text(
                      "Ya",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> showDialogAdd(int id, List barang) async {
    showDialog(
        context: context,
        builder: (context) {
          return TransaksiDialogAdd(id: id, a: barang);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: 190,
            ),
            FutureBuilder<List<TransaksiModel>>(
              future: _getTransaksi,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  final transaksis = snapshot.data ?? [];
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 40),
                    child: Column(
                      children: transaksis
                          .map((transaksi) => GestureDetector(
                                onTap: () {},
                                // child: CoinCard(coin: coin),
                                child: TransaksiCard(transaksi: transaksi),
                              ))
                          .toList(),
                    ),
                  );
                }
                // Loading state
                return const Center(child: Text("Loading"));
              },
            ),

            // TODO: "ini Merupakan data stream ;)"
            // StreamBuilder<dynamic>(
            //     stream: dataTransaksi.stream,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError) {
            //         return Text(snapshot.error.toString());
            //       } else if (snapshot.hasData) {
            //         var jumlahData = snapshot.data!.length;
            //         var data = snapshot.data;
            //         // print(jumlahData);
            //         return Container(
            //           width: double.infinity,
            //           height: MediaQuery.of(context).size.height,
            //           color: Colors.white,
            //           child: ListView.builder(
            //             itemCount: jumlahData,
            //             itemBuilder: (context, index) {
            //               var str = data[index]['tanggal_transaksi'];
            //               var arr = str.split('T');
            //               var tanggal = arr[0].split('-');
            //               var tanggalfix =
            //                   '${tanggal[2]}-${tanggal[1]}-${tanggal[0]}';
            //               var idBelakang = data[jumlahData - 1]['id_transaksi'];
            //               idTerakhir = idBelakang;
            //               // print(idBelakang);
            //               return Padding(
            //                 padding: const EdgeInsets.only(
            //                     left: 8.0, right: 8.0, top: 4, bottom: 4),
            //                 child: Container(
            //                   height: 50,
            //                   width: double.infinity,
            //                   decoration: BoxDecoration(
            //                     color: Colors.grey[200],
            //                     borderRadius: BorderRadius.circular(8),
            //                   ),
            //                   child: Padding(
            //                     padding: const EdgeInsets.only(left: 15.0),
            //                     child: Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceAround,
            //                       children: [
            //                         Expanded(
            //                             flex: 1,
            //                             child:
            //                                 Text(data[index]['nama_barang'])),
            //                         Expanded(
            //                           flex: 1,
            //                           child: Text(data[index]['jumlah_terjual']
            //                               .toString()),
            //                         ),
            //                         Expanded(flex: 1, child: Text(tanggalfix)),
            //                         IconButton(
            //                             onPressed: () {
            //                               // deleteDataTransaksi(
            //                               //     data[index]['id_transaksi']);
            //                               showDialogDelete(
            //                                   context,
            //                                   "Apakah Anda yakin ingin menghapus data ini?",
            //                                   data[index]['id_transaksi']);
            //                             },
            //                             icon: Icon(
            //                               Icons.delete,
            //                               size: 18,
            //                               color: Colors.red,
            //                             ))
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         );
            //       } else if (snapshot.connectionState != ConnectionState.done) {
            //         return Container(
            //           height: 200,
            //           child: Center(
            //             child: CircularProgressIndicator(),
            //           ),
            //         );
            //       } else if (!snapshot.hasData &&
            //           snapshot.connectionState == ConnectionState.done) {
            //         return Expanded(
            //             child: Center(child: Text('Tidak Ada Data')));
            //       } else {
            //         return Expanded(
            //             child: Center(child: Text('Tidak Ada Data')));
            //       }
            //     }),
            // StreamBuilder(
            //   stream: dataBarang.stream,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return SizedBox(
            //         height: 1,
            //       );
            //     } else if (snapshot.hasData) {
            //       var jumlahData = snapshot.data!.length;
            //       var data = snapshot.data;
            //       var nama = List<String>.generate(0, (_) => [].toString());
            //       for (var i = 0; i < jumlahData; i++) {}
            //       return SizedBox(
            //         height: 1,
            //       );
            //     } else if (snapshot.connectionState != ConnectionState.done) {
            //       return SizedBox(
            //         height: 1,
            //       );
            //     } else if (!snapshot.hasData &&
            //         snapshot.connectionState == ConnectionState.done) {
            //       return SizedBox(
            //         height: 1,
            //       );
            //     } else {
            //       return SizedBox(
            //         height: 1,
            //       );
            //     }
            //   },
            // ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Data Transaksi",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Nama\nBarang",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Jumlah\nTerjual",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Tanggal",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "act",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 60,
            width: double.infinity,
            // color: Colors.red,
            child: Center(
                child: InkWell(
              onTap: () {
                showDialogAdd(idTerakhir + 1, namaBarang);
              },
              child: Container(
                height: 40,
                width: 140,
                // color: Colors.green,
                decoration: BoxDecoration(
                    color: BaseTheme.color,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  "Tambah Transaksi",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
              ),
            )),
          ),
        )
      ],
    );
  }
}
