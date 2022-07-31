import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/services/transaksi_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';
import 'package:http/http.dart' as http;

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  // List dataTransaksi = [];
  late StreamController dataTransaksi;
  bool isDataLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    // fetchDataTransaksi();
    dataTransaksi = new StreamController();
    Timer.periodic(Duration(milliseconds: 300), (_) {
      loadDataTransaksi();
    });
    super.initState();
  }

  Future fetchDataTransaksi() async {
    try {
      isDataLoading = true;
      final response =
          await http.get(Uri.tryParse('http://192.168.8.101:5000/Transaksi')!);
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: 105,
            ),
            StreamBuilder<dynamic>(
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
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 4, bottom: 4),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              color: Colors.grey,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(data[index]['nama_barang']),
                                  Text(
                                      data[index]['jumlah_terjual'].toString()),
                                  Text(tanggalfix),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                    // return ListView.builder(
                    //   itemBuilder: (context, index) {
                    //     return Padding(
                    //       padding: const EdgeInsets.only(
                    //           left: 8.0, right: 8.0, top: 4, bottom: 4),
                    //       child: Container(
                    //         height: 50,
                    //         width: double.infinity,
                    //         color: Colors.grey,
                    //       ),
                    //     );
                    //   },
                    // );
                  } else if (snapshot.connectionState != ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4, bottom: 4),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    );
                  } else if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Expanded(
                        child: Center(child: Text('Tidak Ada Data')));
                  } else {
                    return Expanded(
                        child: Center(child: Text('Tidak Ada Data')));
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
                height: 70,
                width: double.infinity,
                color: Colors.red,
              ),
              Container(
                height: 30,
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Nama Barang"),
                      Text("Stok Keluar"),
                      Text("Tanggal"),
                    ],
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
            )),
          ),
        )
      ],
    );
  }
}
