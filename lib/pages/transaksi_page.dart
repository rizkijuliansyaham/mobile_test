import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:test_qtasnim/models/barang.dart';
import 'package:test_qtasnim/models/transaksi_model.dart';
import 'package:test_qtasnim/pages/barang_page.dart';
import 'package:test_qtasnim/services/barang_repo.dart';
import 'package:test_qtasnim/services/transaksi_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:test_qtasnim/utils/url_data.dart';
import 'package:test_qtasnim/widgets/barang_card.dart';
import 'package:test_qtasnim/widgets/transaksi_card.dart';
import 'package:test_qtasnim/widgets/transaksi_dialog.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final TextEditingController searchC = TextEditingController();
  String kataCari = "";
  late Future<List<TransaksiModel>> _getTransaksi;
  late Future<List<BarangModel>> _getBarang;
  // List dataTransaksi = [];
  final _formKey = GlobalKey<FormState>();
  late StreamController dataTransaksi;
  // late StreamController dataBarang;
  List namaBarang = [];
  List jenisBarang = [];

  bool isDataLoading = false;
  int idTerakhir = 0;
  Timer? _timer;

  @override
  void initState() {
    _getTransaksi = TransaksiRepo().getTransaksi();
    _getBarang = BarangRepo().getBarang();

    // print(_getTransaksi);
    // DateTime currentDate = DateTime.now();
    dataTransaksi = new StreamController();
    // dataBarang = new StreamController();
    _timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      loadDataTransaksi();
      // loadDataBarang();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future fetchDataTransaksi() async {
    try {
      isDataLoading = true;
      final response =
          await http.get(Uri.tryParse('${DataUrl.baseUrl}Transaksi')!);
      if (response.statusCode == 200) {
        // print(response.body);
        return json.decode(response.body);
        // final response = await TransaksiRepo.getDataTransaksi();
        // print(response);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    } finally {
      isDataLoading = false;
    }
    // await TransaksiRepo.getDataTransaksi();
    // dataTransaksi.addAll(TransaksiRepo.transaksiModel!.);
  }

  loadDataTransaksi() async {
    fetchDataTransaksi().then((res) async {
      dataTransaksi.add(res);
      return res;
    });
  }

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
                  deleteDataTransaksi(id);
                  Navigator.of(context).pop();
                  setState(() {
                    _getTransaksi = TransaksiRepo().getTransaksi();
                  });
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

  Future<void> showDialogAdd(int id, List barang, List jenis) async {
    showDialog(
        context: context,
        builder: (context) {
          return TransaksiDialogAdd(id: id, barang: barang, jenis: jenis);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //TODO: Tinggal ubah uncoment untuk mengubah model jenis data list future atau stream
        // _listTransaksi(),

        Padding(
          padding: const EdgeInsets.only(top: 200),
          child: _listTransaksiStream(),
        ),
        _header(),
        _addTransaksi(),
        Visibility(visible: true, child: _listBarang()),
      ],
    );
  }

  Widget _listBarang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<BarangModel>>(
          future: _getBarang,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              final barang = snapshot.data ?? [];
              var barangGet = List<String>.generate(0, (_) => [].toString());
              var jenisGet =
                  List<int>.generate(0, (_) => int.parse([].toString()));
              List data = barang.map(
                (e) {
                  barangGet.add('${e.namaBarang}');
                  jenisGet.add(int.parse(e.idJenis.toString()));
                  // idBelakang = int.parse(e.idJenis.toString());
                  // idGet.add(int.parse(e.idJenis.toString()));
                  // // jenisGet.add('${e.idJenis}, ${e.jenisBarang}');
                  // jenisGet.add('${e.jenisBarang}');

                  // idJenis.add(int.parse(e.idJenis.toString()));
                },
              ).toList(); // Ngakalin get nama barang lisy
              // print(barangGet);
              namaBarang = barangGet;
              jenisBarang = jenisGet;
              return Container();
            } else {
              return const Text("Tidak ada barang");
            }
          },
        )
      ],
    );
  }

  Widget _search() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
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
    );
  }

  Widget _listTransaksiStream() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<dynamic>(
          stream: dataTransaksi.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              var jumlahData = snapshot.data!.length;
              var data = snapshot.data;
              print(jumlahData);
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: jumlahData,
                  itemBuilder: (context, index) {
                    var str = data[index]['tanggal_transaksi'];
                    var arr = str.split('T');
                    var tanggal = arr[0].split('-');
                    var tanggalfix =
                        '${tanggal[2]}-${tanggal[1]}-${tanggal[0]}';
                    idTerakhir = data[jumlahData - 1]['id_transaksi'];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(data[index]['nama_barang'])),
                              Expanded(
                                flex: 1,
                                child: Text(
                                    data[index]['jumlah_terjual'].toString()),
                              ),
                              Expanded(flex: 1, child: Text(tanggalfix)),
                              IconButton(
                                  onPressed: () {
                                    // deleteDataTransaksi(
                                    //     data[index]['id_transaksi']);
                                    showDialogDelete(
                                        context,
                                        "Apakah Anda yakin ingin menghapus data ini?",
                                        data[index]['id_transaksi']);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.connectionState != ConnectionState.done) {
              // return Padding(
              //   padding: const EdgeInsets.only(
              //       left: 8.0, right: 8.0, top: 4, bottom: 4),
              //   child: Container(
              //     height: 50,
              //     width: double.infinity,
              //     color: Colors.grey,
              //   ),
              return Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ));
            } else if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(child: Text('Tidak Ada Data')),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Center(child: Text('Tidak Ada Data')),
              );
            }
            // return Padding(
            //   padding: const EdgeInsets.only(
            //       left: 8.0, right: 8.0, top: 4, bottom: 4),
            //   child: Container(
            //     height: 50,
            //     width: double.infinity,
            //     color: Colors.grey,
            //   ),
            // );
          }),
    );
  }

  Widget _listTransaksi() {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        SizedBox(
          height: 200,
        ),
        FutureBuilder<List<TransaksiModel>>(
          future: _getTransaksi,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              final transaksis = snapshot.data ?? [];
              // ngakalin id terakhir
              List data = transaksis.map(
                (e) {
                  // barangGet.add('${e.namaBarang}');
                  // jenisGet.add(int.parse(e.idJenis.toString()));
                  idTerakhir = int.parse(e.idTransaksi.toString());
                  // idGet.add(int.parse(e.idJenis.toString()));
                  // // jenisGet.add('${e.idJenis}, ${e.jenisBarang}');
                  // jenisGet.add('${e.jenisBarang}');

                  // idJenis.add(int.parse(e.idJenis.toString()));
                },
              ).toList(); //

              print(idTerakhir);

              return Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 40),
                child: Column(
                  children: transaksis
                      .map((transaksi) => GestureDetector(
                            onTap: () {},
                            // child: CoinCard(coin: coin),
                            child: Stack(
                              children: [
                                TransaksiCard(transaksi: transaksi),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, right: 5),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                        onPressed: () {
                                          showDialogDelete(
                                              context,
                                              "Apakah Anda yakin ingin menghapus data ini?",
                                              transaksi.idTransaksi!);
                                        },
                                        icon: Icon(
                                          Icons.delete_outline_outlined,
                                          size: 18,
                                          color: Colors.red,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              );
            }
            // Loading state
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: CircularProgressIndicator(),
            ));
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
    );
  }

  Widget _header() {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            // color: Colors.green,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/transaksi.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Text(
                      "Data Transaksi",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = Color.fromARGB(255, 99, 92, 92)),
                    ),
                    Text(
                      "Data Transaksi",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _search(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 60,
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
    );
  }

  Widget _addTransaksi() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 60,
        width: double.infinity,
        // color: Colors.red,
        child: Center(
            child: InkWell(
          onTap: () {
            showDialogAdd(idTerakhir + 1, namaBarang, jenisBarang);
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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )),
          ),
        )),
      ),
    );
  }
}
