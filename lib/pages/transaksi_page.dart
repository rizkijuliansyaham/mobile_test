import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:test_qtasnim/models/transaksi_model.dart';
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
  DateTime currentDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  late StreamController dataTransaksi;
  late StreamController dataBarang;

  bool isDataLoading = false;
  int idTerakhir = 0;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    // fetchDataTransaksi();
    DateTime currentDate = DateTime.now();
    dataTransaksi = new StreamController();

    dataBarang = new StreamController();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        print(currentDate);
      });
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

  Future fetchDataBarang() async {
    try {
      isDataLoading = true;
      final response =
          await http.get(Uri.tryParse('http://192.168.8.101:5000/Barang')!);
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

  loadDataBarang() async {
    fetchDataBarang().then((res) async {
      dataBarang.add(res);
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

  Future<void> showDialogAdd(BuildContext context, int id) async {
    showDialog(
        context: context,
        builder: (context) {
          final TextEditingController namaBarang = TextEditingController();
          final TextEditingController jumlahTerjual = TextEditingController();

          return AlertDialog(
            content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Tambah Transaksi",
                        style: TextStyle(
                            color: BaseTheme.color,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: namaBarang,
                      decoration: InputDecoration(
                          hintText: 'Contoh : Teh', labelText: 'Nama Barang'),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "Harus diisi";
                        }
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: jumlahTerjual,
                      decoration: InputDecoration(
                          hintText: 'Contoh : 12', labelText: 'Jumlah Terjual'),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "Harus diisi";
                        }
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: Icon(Icons.date_range_outlined))
                  ],
                )),
            actions: [
              InkWell(
                onTap: (() {
                  if (_formKey.currentState!.validate()) {
                    // putStatusKontrolAuto(1, index);
                    int id_transaksi = id + 1;

                    String nama_barang = namaBarang.text.toString();
                    int jumlah_terjual =
                        int.parse(jumlahTerjual.text.toString());
                    String tanggal = currentDate.toString();
                    List<String> tanggalSplit = tanggal.split(' ');
                    String tanggal_transaksi = '${tanggalSplit[0]}';
                    print(tanggal_transaksi);
                    // putStatusKontrolParameter("$parameter", index);
                    TransaksiRepo.addTransaksi(
                        id, nama_barang, jumlah_terjual, tanggal_transaksi);

                    Navigator.of(context).pop();
                  }
                }),
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: BaseTheme.color,
                      borderRadius: BorderRadius.circular(4)),
                  child: Center(
                    child: Text(
                      "Tambah",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
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
              height: 100,
            ),
            StreamBuilder<dynamic>(
                stream: dataTransaksi.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    var jumlahData = snapshot.data!.length;
                    var data = snapshot.data;
                    // print(jumlahData);

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

                          var idBelakang = data[jumlahData - 1]['id_transaksi'];
                          idTerakhir = idBelakang;

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
                                      child: Text(data[index]['jumlah_terjual']
                                          .toString()),
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
          child: Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
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
              Container(
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
                showDialogAdd(context, idTerakhir + 1);
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
