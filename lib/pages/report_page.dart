import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/models/jenis.dart';
import 'package:test_qtasnim/models/transaksi_model.dart';
import 'package:test_qtasnim/services/jenis_repo.dart';
import 'package:test_qtasnim/services/transaksi_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<List<JenisModel>> _getJenis;
  late Future<List<TransaksiModel>> _getTransaksi;
  List idJenis = [];
  List namaJenis = [];
  List namaBarang = [];
  List namaBarangTerbanyak = []; // Final
  List namaBarangTerkecil = []; // final
  List jumlahBarang = [];
  List idJenisBarang = [];
  List jumlahBarangTerbanyak = [];
  List jumlahBarangTerkecil = [];
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    _getJenis = JenisRepo().getJenis();
    _getTransaksi = TransaksiRepo().getTransaksi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25, 30, 25, 15),
          child: Column(
            children: [
              _tanggal(),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder<List<JenisModel>>(
                future: _getJenis,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    final jenis = snapshot.data ?? [];
                    var jenisGet =
                        List<String>.generate(0, (_) => [].toString());
                    var idGet =
                        List<int>.generate(0, (_) => int.parse([].toString()));

                    List data = jenis.map(
                      (e) {
                        idGet.add(int.parse(e.idJenis.toString()));
                        jenisGet.add('${e.jenisBarang}');
                      },
                    ).toList();
                    idJenis = idGet;
                    namaJenis = jenisGet;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Data Jenis ada"),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Jenis tidak ada"),
                      ],
                    );
                  }
                },
              ),
              FutureBuilder<List<TransaksiModel>>(
                future: _getTransaksi,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    final transaksi = snapshot.data ?? [];
                    var namaGet =
                        List<String>.generate(0, (_) => [].toString());
                    var barangTerbanyakGet =
                        List<String>.generate(0, (_) => [].toString());
                    var barangTerdikitGet =
                        List<String>.generate(0, (_) => [].toString());
                    var jumlahGet =
                        List<int>.generate(0, (_) => int.parse([].toString()));
                    var jumlahTerbanyakGet =
                        List<int>.generate(0, (_) => int.parse([].toString()));
                    var jumlahTerdikitGet =
                        List<int>.generate(0, (_) => int.parse([].toString()));
                    var idJenisGet =
                        List<int>.generate(0, (_) => int.parse([].toString()));

                    List data = transaksi.map(
                      (e) {
                        jumlahGet.add(int.parse(e.jumlahTerjual.toString()));
                        idJenisGet.add(int.parse(e.idJenis.toString()));
                        namaGet.add('${e.namaBarang}');
                      },
                    ).toList();
                    // idJenis = idGet;
                    // namaJenis = jenisGet;
                    namaBarang = namaGet;
                    jumlahBarang = jumlahGet;
                    idJenisBarang = idJenisGet;

// TODO: logika jumlah terbanyak
                    for (var i = 0; i < namaJenis.length; i++) {
                      var namaBarangTinggi = "";
                      var jumlahBarangTinggi = 0;
                      for (var j = 0; j < namaBarang.length; j++) {
                        if (jumlahBarang[j] > jumlahBarangTinggi &&
                            idJenis.elementAt(i) == idJenisBarang[j]) {
                          namaBarangTinggi = namaBarang[j];
                          jumlahBarangTinggi = jumlahBarang[j];
                        } else {
                          namaBarangTinggi = namaBarangTinggi;
                          jumlahBarangTinggi = jumlahBarangTinggi;
                        }
                      }
                      barangTerbanyakGet.add(namaBarangTinggi);
                      jumlahTerbanyakGet.add(jumlahBarangTinggi);
                    }

                    namaBarangTerbanyak = barangTerbanyakGet;
                    jumlahBarangTerbanyak = jumlahTerbanyakGet;

// TODO: logika jumlah terkecil
                    for (var i = 0; i < namaJenis.length; i++) {
                      var namaBarangKecil = "";
                      var jumlahBarangKecil = 10000;
                      for (var j = 0; j < namaBarang.length; j++) {
                        if (jumlahBarang[j] < jumlahBarangKecil &&
                            idJenis.elementAt(i) == idJenisBarang[j]) {
                          namaBarangKecil = namaBarang[j];
                          jumlahBarangKecil = jumlahBarang[j];
                        } else {
                          namaBarangKecil = namaBarangKecil;
                          jumlahBarangKecil = jumlahBarangKecil;
                        }
                      }
                      barangTerdikitGet.add(namaBarangKecil);
                      jumlahTerdikitGet.add(jumlahBarangKecil);
                    }

                    namaBarangTerkecil = barangTerdikitGet;
                    jumlahBarangTerkecil = jumlahTerdikitGet;

                    // print('nama terbanyak : $namaBarangTerbanyak');
                    // print('jumlah terbanyak : $jumlahBarangTerbanyak');

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Data Transaksi ada"),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("data transaksi tidak ada"),
                      ],
                    );
                  }
                },
              ),
              _dataTerbanyak(),
              const SizedBox(
                height: 30,
              ),
              _dataDikit()
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
              width: 180,
              child: Text(
                  "Tekan ini >>>>>>>>\nuntuk ambil data :') karena masih terbuat dengan future")),
          FloatingActionButton(
            onPressed: () {
              setState(() {});
            },
            child: const Icon(Icons.download),
            backgroundColor: BaseTheme.color,
            mini: true,
          ),
        ],
      ),
    );
  }

  Widget _tanggal() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Tanggal 1"),
          Text("  -  "),
          Text("Tanggal 2"),
        ],
      ),
    );
  }

  Widget _dataDikit() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Data Terkecil"),
            const SizedBox(height: 30),
            Row(children: [
              Expanded(flex: 1, child: Center(child: Text("Jenis Barang"))),
              Expanded(flex: 1, child: Center(child: Text("Nama Barang"))),
              Expanded(flex: 1, child: Center(child: Text("Jumlah"))),
            ]),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            namaJenis.map((item) => Text(item)).toList())),
                Expanded(
                    flex: 1,
                    child: Column(
                        children: namaBarangTerkecil
                            .map(
                                (nama) => nama != "" ? Text(nama) : Text(" - "))
                            .toList())),
                Expanded(
                    flex: 1,
                    child: Column(
                        children: jumlahBarangTerkecil
                            .map((jumlah) => jumlah != 10000
                                ? Text(jumlah.toString())
                                : Text(" - "))
                            .toList())),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _dataTerbanyak() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Data Terbanyak"),
            const SizedBox(height: 30),
            Row(children: [
              Expanded(flex: 1, child: Center(child: Text("Jenis Barang"))),
              Expanded(flex: 1, child: Center(child: Text("Nama Barang"))),
              Expanded(flex: 1, child: Center(child: Text("Jumlah"))),
            ]),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            namaJenis.map((item) => Text(item)).toList())),
                Expanded(
                    flex: 1,
                    child: Column(
                        children: namaBarangTerbanyak
                            .map(
                                (nama) => nama != "" ? Text(nama) : Text(" - "))
                            .toList())),
                Expanded(
                    flex: 1,
                    child: Column(
                        children: jumlahBarangTerbanyak
                            .map((jumlah) => jumlah != 0
                                ? Text(jumlah.toString())
                                : Text(" - "))
                            .toList())),
              ],
            )
          ],
        ),
      ),
    );
  }
}
