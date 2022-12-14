// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:test_qtasnim/models/barang.dart';
import 'package:test_qtasnim/models/jenis.dart';
import 'package:test_qtasnim/services/barang_repo.dart';
import 'package:test_qtasnim/services/jenis_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';
import 'package:test_qtasnim/utils/url_data.dart';
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
  late StreamController dataTransaksiSearch;
  late Future<List<BarangModel>> _getBarang;
  late Future<List<JenisModel>> _getJenis;
  String kataCari = "";
  int idJenisTerakhir = 0;
  List idJenis = [];
  List namaJenis = [];
  Timer? _timer;
  bool isDataLoading = false;

  @override
  void initState() {
    _getBarang = BarangRepo().getBarang();
    _getJenis = JenisRepo().getJenis();
    dataTransaksiSearch = StreamController();

    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      loadDataTransaksiSearch();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> showDialogEditBarang(int stok, String namaBarang) async {
    showDialog(
        context: context,
        builder: (context) {
          return BarangEdit(stok: stok, namaBarang: namaBarang);
        });
  }

  Future fetchDataTransaksiSearch() async {
    try {
      isDataLoading = true;
      final response = await http.get(
          Uri.tryParse('${DataUrl.baseUrl}search2?search_query=$kataCari')!);
      if (response.statusCode == 200) {
        // print(response.body);
        return json.decode(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    } finally {
      isDataLoading = false;
    }
  }

  loadDataTransaksiSearch() async {
    fetchDataTransaksiSearch().then((res) async {
      dataTransaksiSearch.add(res);
      return res;
    });
  }

  Widget _listTransaksiSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 30, left: 15),
          child: Text(
            "Riwayat Penjualanmu",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Nama\nBarang",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Jumlah\nTerjual",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Tanggal",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    "act",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: StreamBuilder<dynamic>(
              stream: dataTransaksiSearch.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  var jumlahData = snapshot.data!['result'].length;
                  var data = snapshot.data['result'];
                  // print(jumlahData);

                  if (jumlahData != 0) {
                    return SizedBox(
                      width: double.infinity,
                      height: 180,
                      // color: Colors.white,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
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
                                        icon: const Icon(
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text("Transaksi yang dicari tidak ada"),
                        ],
                      ),
                    );
                  }
                } else if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return const Expanded(
                      child: Center(child: Text('Tidak Ada Data')));
                } else {
                  return const Expanded(
                      child: Center(child: Text('Tidak Ada Data')));
                }
              }),
        ),
        const SizedBox(
          height: 70,
        ),
      ],
    );
  }

  Future<void> showDialogAddJenis(
      int id, Future<List<JenisModel>> _getJenis) async {
    showDialog(
        context: context,
        builder: (context) {
          return AddJenis(id: id);
        });
  }

  Future<void> showDialogAddBarang(
      List<dynamic> namaJenis, List<dynamic> idJenis) async {
    showDialog(
        context: context,
        builder: (context) {
          return BarangDialogAdd(nama: namaJenis, idJenis: idJenis);
        });
  }

  void deleteDataBarang(String nama) async {
    var delete = await BarangRepo.deleteBarang(nama);
  }

  Future<void> showDialogDeleteBarang(
      BuildContext context, String pesan, String nama) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(pesan,
                    style: const TextStyle(
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
                  child: const Center(
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
                  BarangRepo.deleteBarang(nama);
                  Navigator.of(context).pop();
                }),
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4)),
                  child: const Center(
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
                    style: const TextStyle(
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
                  child: const Center(
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
                  child: const Center(
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
              Visibility(
                  visible: kataCari != null, child: _listTransaksiSearch()),
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

  Widget _header() {
    return SizedBox(
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
              style: TextStyle(
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
                            // ignore: unnecessary_null_comparison
                            if (searchC.text != null) {
                              kataCari = searchC.text;
                              print(kataCari);
                            } else {
                              kataCari = "undef";
                            }
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
                          hintText: 'Cari Data Transaksi',
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
    return SizedBox(
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
                  style: TextStyle(
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
          SizedBox(
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
                                                          "Menghapus data jenis akan berpengaruh kepada perubahan seluruh jenis barang yang terhubung akan dipindahkan ke kategori 'Lain-lain' Apakah Anda yakin ingin menghapus ${item.jenisBarang.toString()}?",
                                                          int.parse(item.idJenis
                                                              .toString()));
                                                    },
                                                    child: const Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ))
                            .toList());
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Tidak ada data jenis barang"),
                      ],
                    );
                  }
                },
              ),
            ),
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

  Widget _listBarang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 15),
          child: Text(
            "Barang yang kamu punya",
            style: TextStyle(
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
                                onTap: () {
                                  showDialogEditBarang(
                                      int.parse(barangs.stok.toString()),
                                      barangs.namaBarang.toString());
                                },
                                child: Stack(
                                  children: [
                                    BarangCard(barang: barangs),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 22, top: 6),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            showDialogDeleteBarang(
                                                context,
                                                "Apakah yakin akan menghapus data ${barangs.namaBarang.toString()}?",
                                                barangs.namaBarang.toString());
                                          },
                                          child: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemCount: 1);
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Tidak ada barang"),
                  ],
                ),
              );
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
              },
              separatorBuilder: (context, index) => const SizedBox(),
              itemCount: 1);
        } else {
          return const Text("Tidak ada barang");
        }
      },
    );
  }
}
