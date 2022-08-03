import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:test_qtasnim/models/barang.dart';
import 'package:test_qtasnim/models/jenis.dart';
import 'package:test_qtasnim/services/barang_repo.dart';
import 'package:test_qtasnim/services/jenis_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';
import 'package:test_qtasnim/widgets/barang_card.dart';
import 'package:test_qtasnim/widgets/barang_dialog.dart';
import 'package:test_qtasnim/widgets/jenis_card.dart';
import 'package:test_qtasnim/widgets/jenis_dialog.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({Key? key}) : super(key: key);

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  final TextEditingController searchC = TextEditingController();
  late Future<List<BarangModel>> _getBarang;
  late Future<List<JenisModel>> _getJenis;
  String kataCari = "";
  int idJenisTerakhir = 0;
  List idJenis = [];
  List namaJenis = [];
  // late StreamController dataBarang;
  // late StreamController dataJenis;
  // List namaBarang = [];
  // List namaJenis = [];
  // List idJenis = [];
  // List testList = ["satu", "dua"];
  // bool isDataLoading = false;
  // Timer? _timer;
  // final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _getBarang = BarangRepo().getBarang();
    _getJenis = JenisRepo().getJenis();
    kataCari = "";

    List idJenis = [];
    List namaJenis = [];

    // dataBarang = new StreamController();
    // dataJenis = new StreamController();
    // _timer = Timer.periodic(Duration(milliseconds: 300), (_) {
    //   // loadDataTransaksi();
    //   loadDataBarang();
    //   loadDataJenis();
    // });
    super.initState();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  Future<void> showDialogAddJenis(
      int id, Future<List<JenisModel>> _getJenis) async {
    showDialog(
        context: context,
        builder: (context) {
          // return TransaksiDialogAdd(id: id, a: barang);
          // return Container();
          // return AddJeniss(id: id, getJenis: _getJenis);
          return AddJenis(id: id);
        });
  }
  // Future fetchDataBarang() async {
  //   try {
  //     isDataLoading = true;
  //     final response =
  //         await http.get(Uri.tryParse('http://192.168.8.100:5000/Barang')!);
  //     if (response.statusCode == 200) {
  //       // print(response.body);
  //       return json.decode(response.body);
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

  // loadDataBarang() async {
  //   fetchDataBarang().then((res) async {
  //     dataBarang.add(res);
  //     return res;
  //   });
  // }

  // Future fetchDataJenis() async {
  //   try {
  //     isDataLoading = true;
  //     final response =
  //         await http.get(Uri.tryParse('http://192.168.8.100:5000/Jenis')!);
  //     if (response.statusCode == 200) {
  //       // print(response.body);
  //       return json.decode(response.body);
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

  // loadDataJenis() async {
  //   fetchDataJenis().then((res) async {
  //     dataJenis.add(res);
  //     return res;
  //   });
  // }

  Future<void> showDialogAddBarang(
      List<dynamic> namaJenis, List<dynamic> idJenis) async {
    showDialog(
        context: context,
        builder: (context) {
          return BarangDialogAdd(nama: namaJenis, idJenis: idJenis);
        });
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
                      color: Colors.red,
                    )),
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
                      border: Border.all(color: Colors.red, width: 0.4)),
                  child: Center(
                    child: Text(
                      "Tidak",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (() {
                  JenisRepo.deleteTransaksi(id);
                  Navigator.of(context).pop();
                }),
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              Visibility(visible: kataCari == "", child: _jenis()),
              Visibility(visible: kataCari == "", child: _tambahBarang()),
              Visibility(visible: kataCari == "", child: _listBarang()),
              Visibility(visible: kataCari != "", child: _searchValue()),

              // Container(
              //   height: 450,
              //   color: Colors.amber,
              // ),
              // ListView.separated(
              //     itemBuilder: (context, index) {
              //       return Container();
              //     },
              //     separatorBuilder: (context, index) => Divider(),
              //     itemCount: 3)
              // StaggeredGridView.countBuilder(
              //   crossAxisCount: 2,
              //   itemBuilder: (context, index) {
              //     return Container(
              //       height: 10,
              //       width: 10,
              //       color: Colors.red,
              //     );
              //   },
              //   staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              // )
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: kataCari == "",
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _getJenis = JenisRepo().getJenis();
              _getBarang = BarangRepo().getBarang();
            });
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  } // coment ini kalau mau mengggunakan layout lama

// TODO: Layout Lama
  // return ListView(
  //   children: [
  //     Expanded(
  //       flex: 1,
  //       child: Container(
  //         width: MediaQuery.of(context).size.width,
  //         // color: Colors.red,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(
  //               height: 20,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 10.0),
  //               child: Text(
  //                 "Barang",
  //                 style: TextStyle(
  //                   fontSize: 30,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),

  // TODO: Stream Barang
  //             // StreamBuilder<dynamic>(
  //             //     stream: dataBarang.stream,
  //             //     builder: (context, snapshot) {
  //             //       if (snapshot.hasError) {
  //             //         return Text(snapshot.error.toString());
  //             //       } else if (snapshot.hasData) {
  //             //         var jumlahData = snapshot.data!.length;
  //             //         var data = snapshot.data;
  //             //         // List dataNama = [;
  //             //         // namaBarang.addAll(dataNama);
  //             //         // print(dataNama);
  //             //         return Container(
  //             //             height: 180,
  //             //             // color: Colors.black,
  //             //             child: ListView.builder(
  //             //               physics: BouncingScrollPhysics(),
  //             //               scrollDirection: Axis.horizontal,
  //             //               itemCount: jumlahData,
  //             //               itemBuilder: (context, index) {
  //             //                 return Padding(
  //             //                   padding: const EdgeInsets.all(8.0),
  //             //                   child: Container(
  //             //                     height: 12,
  //             //                     width: 140,
  //             //                     decoration: BoxDecoration(
  //             //                       color: Colors.grey[200],
  //             //                       borderRadius: BorderRadius.circular(12),
  //             //                     ),
  //             //                     child: Padding(
  //             //                       padding: const EdgeInsets.all(8.0),
  //             //                       child: Column(
  //             //                           crossAxisAlignment:
  //             //                               CrossAxisAlignment.start,
  //             //                           mainAxisAlignment:
  //             //                               MainAxisAlignment.spaceAround,
  //             //                           children: [
  //             //                             Text(
  //             //                               data[index]['nama_barang'],
  //             //                               style: TextStyle(
  //             //                                 fontSize: 26,
  //             //                               ),
  //             //                             ),
  //             //                             // SizedBox(
  //             //                             //   height: 80,
  //             //                             // ),
  //             //                             Text(
  //             //                                 "Stok : ${data[index]['stok']}"),
  //             //                           ]),
  //             //                     ),
  //             //                   ),
  //             //                 );
  //             //               },
  //             //             ));
  //             //       } else if (snapshot.connectionState !=
  //             //           ConnectionState.done) {
  //             //         return Container(
  //             //           height: 200,
  //             //           child: Center(
  //             //             child: CircularProgressIndicator(),
  //             //           ),
  //             //         );
  //             //       } else if (!snapshot.hasData &&
  //             //           snapshot.connectionState == ConnectionState.done) {
  //             //         return Expanded(
  //             //             child: Center(child: Text('Tidak Ada Data')));
  //             //       } else {
  //             //         return Expanded(
  //             //             child: Center(child: Text('Tidak Ada Data')));
  //             //       }
  //             //     }),
  //             SizedBox(
  //               height: 12,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(right: 12),
  //               child: Align(
  //                 alignment: Alignment.bottomRight,
  //                 child: Container(
  //                   height: 40,
  //                   width: 140,
  //                   // color: Colors.green,
  //                   decoration: BoxDecoration(
  //                       color: BaseTheme.color,
  //                       borderRadius: BorderRadius.circular(20)),
  //                   child: InkWell(
  //                     onTap: () {
  //                       showDialogAddBarang(namaJenis);
  //                     },
  //                     child: Center(
  //                         child: Text(
  //                       "Tambah Barang",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold, color: Colors.white),
  //                     )),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     // Expanded(
  //     //     flex: 1,
  //     //     child: Container(
  //     //       width: MediaQuery.of(context).size.width,
  //     //       // color: Colors.red,
  //     //       child: Column(
  //     //         crossAxisAlignment: CrossAxisAlignment.start,
  //     //         children: [
  //     //           SizedBox(
  //     //             height: 20,
  //     //           ),
  //     //           Padding(
  //     //             padding: const EdgeInsets.only(left: 10.0),
  //     //             child: Text(
  //     //               "Jenis",
  //     //               style: TextStyle(
  //     //                 fontSize: 30,
  //     //                 fontWeight: FontWeight.bold,
  //     //               ),
  //     //             ),
  //     //           ),
  //     //           SizedBox(
  //     //             height: 20,
  //     //           ),

  // TODO: Stream Jenis
  //     //           // StreamBuilder<dynamic>(
  //     //           //     stream: dataJenis.stream,
  //     //           //     builder: (context, snapshot) {
  //     //           //       if (snapshot.hasError) {
  //     //           //         return Text(snapshot.error.toString());
  //     //           //       } else if (snapshot.hasData) {
  //     //           //         var jumlahData = snapshot.data!.length;
  //     //           //         var data = snapshot.data;
  //  ngakalin get jenis id dan nama
  //     //           //         var jenis =
  //     //           //             List<String>.generate(0, (_) => [].toString());
  //     //           //         var idGet = List<int>.generate(
  //     //           //             0, (_) => int.parse([].toString()));
  //     //           //         // print(jenis);
  //     //           //         for (var i = 0; i < jumlahData; i++) {
  //     //           //           jenis.add(data[i]['jenis_barang']);
  //     //           //           idGet.add(data[i]['id_jenis']);
  //     //           //         }
  //     //           //         namaJenis = jenis;
  //     //           //         idJenis = idGet;
  //     //           //         // print(namaJenis);
  //     //           //         // print(idGet);
  //     //           //         // print(jenis);
  //     //           //         return Container(
  //     //           //             height: 180,
  //     //           //             // color: Colors.black,
  //     //           //             child: ListView.builder(
  //     //           //               physics: BouncingScrollPhysics(),
  //     //           //               scrollDirection: Axis.horizontal,
  //     //           //               itemCount: jumlahData,
  //     //           //               itemBuilder: (context, index) {
  //     //           //                 // jenis.add(data[index]['jenis_barang']);
  //     //           //                 return Padding(
  //     //           //                   padding: const EdgeInsets.all(8.0),
  //     //           //                   child: Container(
  //     //           //                     height: 12,
  //     //           //                     width: 140,
  //     //           //                     decoration: BoxDecoration(
  //     //           //                       color: Colors.grey[200],
  //     //           //                       borderRadius: BorderRadius.circular(12),
  //     //           //                     ),
  //     //           //                     child: Padding(
  //     //           //                       padding: const EdgeInsets.all(8.0),
  //     //           //                       child: Column(
  //     //           //                           crossAxisAlignment:
  //     //           //                               CrossAxisAlignment.start,
  //     //           //                           mainAxisAlignment:
  //     //           //                               MainAxisAlignment.spaceAround,
  //     //           //                           children: [
  //     //           //                             Text(
  //     //           //                               data[index]['jenis_barang'],
  //     //           //                               style: TextStyle(
  //     //           //                                 fontSize: 22,
  //     //           //                               ),
  //     //           //                             ),
  //     //           //                             // SizedBox(
  //     //           //                             //   height: 80,
  //     //           //                             // ),
  //     //           //                           ]),
  //     //           //                     ),
  //     //           //                   ),
  //     //           //                 );
  //     //           //               },
  //     //           //             ));
  //     //           //       } else if (snapshot.connectionState !=
  //     //           //           ConnectionState.done) {
  //     //           //         return Container(
  //     //           //           height: 200,
  //     //           //           child: Center(
  //     //           //             child: CircularProgressIndicator(),
  //     //           //           ),
  //     //           //         );
  //     //           //       } else if (!snapshot.hasData &&
  //     //           //           snapshot.connectionState == ConnectionState.done) {
  //     //           //         return Expanded(
  //     //           //             child: Center(child: Text('Tidak Ada Data')));
  //     //           //       } else {
  //     //           //         return Expanded(
  //     //           //             child: Center(child: Text('Tidak Ada Data')));
  //     //           //       }
  //     //           //     })
  //     //         ],
  //     //       ),
  //     //     ))
  //   ],
  // );
  // }

  Widget _header() {
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text("Halo,"),
            const Text(
              "Pengguna",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      child: TextField(
                        controller: searchC,
                        onChanged: (value) {
                          setState(() {
                            kataCari = searchC.text;
                          });
                        },
                        onSubmitted: ((value) {
                          setState(() {
                            // kataCari = searchC.text;
                          });
                        }),
                        // controller: searchC,
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(
                          hintText: 'Searching',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _jenis() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      // color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Jenis Barang",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: InkWell(
                      onTap: () {
                        showDialogAddJenis(idJenisTerakhir + 1, _getJenis);
                      },
                      child: const Icon(Icons.add_circle_outline)),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            // color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: FutureBuilder<List<JenisModel>>(
                future: _getJenis,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    final jenis = snapshot.data ?? [];
                    int idBelakang = 0;
                    var jenisGet =
                        List<String>.generate(0, (_) => [].toString());
                    var idGet =
                        List<int>.generate(0, (_) => int.parse([].toString()));
                    // var jenis =     List<String>.generate(0, (_) => [].toString());
                    List data = jenis.map(
                      (e) {
                        idBelakang = int.parse(e.idJenis.toString());
                        idGet.add(int.parse(e.idJenis.toString()));
                        // jenisGet.add('${e.idJenis}, ${e.jenisBarang}');
                        jenisGet.add('${e.jenisBarang}');

                        // idJenis.add(int.parse(e.idJenis.toString()));
                      },
                    ).toList(); // Ngakalin get id terakhir karena backend belum set auto fill id
                    // print(data);
                    // print(data.length);
                    // print(idGet);
                    print(jenisGet);
                    idJenis = idGet;
                    namaJenis = jenisGet;

                    for (var i = 0; i < data.length; i++) {}

                    idJenisTerakhir = idBelakang;
                    return ListView(
                        scrollDirection: Axis.horizontal,
                        children: jenis
                            .map((item) => GestureDetector(
                                  onTap: () {},
                                  child: Stack(
                                    children: [
                                      JenisCard(jenis: item),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 8, 5, 8),
                                          child: Container(
                                            height: 70,
                                            width: 160,
                                            decoration: BoxDecoration(
                                                // color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12, bottom: 12),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Visibility(
                                                  visible: item.idJenis! > 1,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialogDelete(
                                                          context,
                                                          "Menghapus data jenis akan berpengaruh kepada perubahan seluruh jenis barang yang terhubung ke kategori 'Lain-lain' Apakah Anda yakin ingin menghapus ${item.jenisBarang.toString()}?",
                                                          int.parse(item.idJenis
                                                              .toString()));
                                                      // JenisRepo.deleteTransaksi(
                                                      //     int.parse(item.idJenis
                                                      //         .toString()));
                                                    },
                                                    child: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                      // const Padding(
                                      //   padding:
                                      //       EdgeInsets.only(right: 22, top: 6),
                                      //   child: Align(
                                      //     alignment: Alignment.topRight,
                                      //     child: Icon(
                                      //       Icons.remove_circle_outline,
                                      //       color: Colors.red,
                                      //     ),
                                      //   ),
                                      // ),
                                      // Align(
                                      //   alignment: Alignment.bottomRight,
                                      //   child: Icon(
                                      //     Icons.remove_circle_outline_sharp,
                                      //     color: Colors.red,
                                      //     size: 16,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ))
                            .toList());
                  } else {
                    return Container();
                  }
                },
              ),
            ),

            // TODO: nanti dibuat list jenis
            // child: ListView(
            //   scrollDirection: Axis.horizontal,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //         height: 70,
            //         width: 160,
            //         decoration: BoxDecoration(
            //             color: Colors.grey[200],
            //             borderRadius: BorderRadius.circular(10)),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //         height: 70,
            //         width: 160,
            //         decoration: BoxDecoration(
            //             color: Colors.grey[200],
            //             borderRadius: BorderRadius.circular(10)),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //         height: 70,
            //         width: 160,
            //         decoration: BoxDecoration(
            //             color: Colors.grey[200],
            //             borderRadius: BorderRadius.circular(10)),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }

  Widget _tambahBarang() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        // color: Colors.grey,
        decoration: BoxDecoration(
            border: Border.all(color: BaseTheme.abu, width: 2),
            // color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            const Icon(
              Icons.list_alt_outlined,
              size: 80,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ada Barang Baru?",
                  style: TextStyle(fontSize: 22),
                ),
                InkWell(
                    onTap: () {
                      showDialogAddBarang(namaJenis, idJenis);
                    },
                    child: const Text("Tambah",
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _listBarang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Text(
            "Barang yang kamu punya",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        FutureBuilder<List<BarangModel>>(
          future: _getBarang,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              final barang = snapshot.data ?? [];

              return ListView.separated(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // return BarangCard(barang: barang);
                    return Column(
                      children: barang
                          .map((barangs) => GestureDetector(
                                onTap: () {},
                                child: Stack(
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(right: 22, top: 6),
                                      child: const Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    BarangCard(barang: barangs),
                                  ],
                                ),
                              ))
                          .toList(),
                    );
                    // return StaggeredGridView.countBuilder(
                    //   crossAxisCount: 2,
                    //   itemBuilder: (context, index) {
                    //     return Container(
                    //       height: 10,
                    //       width: 10,
                    //       color: Colors.red,
                    //     );
                    //   },
                    //   staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    // );
                  },
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: 1);

              // return StaggeredGridView.countBuilder(
              //   shrinkWrap: true,
              //   crossAxisCount: 2,
              //   itemBuilder: (context, index) {
              //     return Container(
              //       height: 10,
              //       width: 10,
              //       color: Colors.red,
              //     );
              //   },
              //   staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              // );
            } else {
              return const Text("Tidak ada barang");
            }
          },
        )
      ],
    );
  }

  Widget _searchValue() {
    return FutureBuilder<List<BarangModel>>(
      future: _getBarang,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          final barang = snapshot.data ?? [];

          return ListView.separated(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // return BarangCard(barang: barang);
                return Column(
                  children: barang
                      .map((barangs) => GestureDetector(
                            onTap: () {},
                            child: Stack(
                              children: [
                                BarangCard(barang: barangs),
                                const Padding(
                                  padding: EdgeInsets.only(right: 22, top: 6),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                );
                // return StaggeredGridView.countBuilder(
                //   crossAxisCount: 2,
                //   itemBuilder: (context, index) {
                //     return Container(
                //       height: 10,
                //       width: 10,
                //       color: Colors.red,
                //     );
                //   },
                //   staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                // );
              },
              separatorBuilder: (context, index) => const SizedBox(),
              itemCount: 1);

          // return StaggeredGridView.countBuilder(
          //   shrinkWrap: true,
          //   crossAxisCount: 2,
          //   itemBuilder: (context, index) {
          //     return Container(
          //       height: 10,
          //       width: 10,
          //       color: Colors.red,
          //     );
          //   },
          //   staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          // );
        } else {
          return const Text("Tidak ada barang");
        }
      },
    );
  }
}
