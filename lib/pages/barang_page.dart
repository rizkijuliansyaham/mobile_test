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
    _getBarang = BarangRepo().getTransaksi();
    _getJenis = JenisRepo().getJenis();
    kataCari = "";

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

  Future<void> showDialogAddBarang(List<dynamic> a) async {
    showDialog(
        context: context,
        builder: (context) {
          return BarangDialogAdd(a: a);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            Visibility(visible: kataCari == "", child: _jenis()),
            _tambahBarang(),

            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15),
              child: Text(
                "Barang yang kamu punya",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),

            FutureBuilder<List<BarangModel>>(
              future: _getBarang,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  final barang = snapshot.data ?? [];

                  return ListView.separated(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // return BarangCard(barang: barang);
                        return Column(
                          children: barang
                              .map((barangs) => GestureDetector(
                                    onTap: () {},
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 22, top: 6),
                                          child: Align(
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
                      separatorBuilder: (context, index) => SizedBox(),
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
                  return Text("Tidak ada barang");
                }
              },
            )

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
            SizedBox(
              height: 20,
            ),
            Text("Halo,"),
            Text(
              "Pengguna",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
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
                    SizedBox(
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
                        decoration: InputDecoration(
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
                Text(
                  "Jenis Barang",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(Icons.add_circle_outline),
                    ))
              ],
            ),
          ),
          SizedBox(
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
                    return ListView(
                        scrollDirection: Axis.horizontal,
                        children: jenis
                            .map((item) => GestureDetector(
                                  onTap: () {},
                                  child: JenisCard(jenis: item),
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
            SizedBox(
              width: 12,
            ),
            Icon(
              Icons.list_alt_outlined,
              size: 80,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ada Barang Baru?",
                  style: TextStyle(fontSize: 22),
                ),
                InkWell(
                    onTap: () {},
                    child: Text("Tambah",
                        style: TextStyle(
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
}
