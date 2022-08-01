import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:test_qtasnim/pages/transaksi_page.dart';
import 'package:test_qtasnim/services/transaksi_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String kataCari = "";
  final TextEditingController searchC = TextEditingController();
  late StreamController dataTransaksiSearch;
  Timer? _timer;
  bool isDataLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataTransaksiSearch = new StreamController();
    _timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      loadDataTransaksiSearch();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  Future fetchDataTransaksiSearch() async {
    try {
      isDataLoading = true;
      final response = await http.get(Uri.tryParse(
          'http://192.168.8.100:5000/search2?search_query=$kataCari')!);
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

  loadDataTransaksiSearch() async {
    fetchDataTransaksiSearch().then((res) async {
      dataTransaksiSearch.add(res);
      return res;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: 80,
            ),
            StreamBuilder<dynamic>(
                stream: dataTransaksiSearch.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    var jumlahData = snapshot.data!['result'].length;
                    var data = snapshot.data['result'];
                    // print(jumlahData);

                    if (jumlahData != 0) {
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

                            // print(idBelakang);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 4, bottom: 4),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child:
                                              Text(data[index]['nama_barang'])),
                                      Expanded(
                                        flex: 1,
                                        child: Text(data[index]
                                                ['jumlah_terjual']
                                            .toString()),
                                      ),
                                      Expanded(
                                          flex: 1, child: Text(tanggalfix)),
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
                    } else {
                      return Center(
                          child: Text("Transaksi yang dicari tidak ada"));
                    }
                  } else if (snapshot.connectionState != ConnectionState.done) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
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
                }),
            SizedBox(
              height: 70,
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  kataCari = searchC.text;
                });
              },
              onSubmitted: ((value) {
                setState(() {
                  kataCari = searchC.text;
                });
              }),
              controller: searchC,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Searching',
                // helperText: 'Helper Text',
                // counterText: '0 characters',
                // border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
