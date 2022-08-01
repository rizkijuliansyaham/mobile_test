import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/models/transaksi_model.dart';
import 'package:test_qtasnim/pages/transaksi_page.dart';
import 'package:test_qtasnim/services/transaksi_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';

class TransaksiCard extends StatelessWidget {
  final TransaksiModel transaksi;
  const TransaksiCard({Key? key, required this.transaksi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var str = transaksi.tanggalTransaksi!;
    var arr = str.split('T');
    var tanggal = arr[0].split('-');
    var tanggalfix = '${tanggal[2]}-${tanggal[1]}-${tanggal[0]}';
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(flex: 1, child: Text(transaksi.namaBarang.toString())),
              Expanded(
                flex: 1,
                child: Text(transaksi.jumlahTerjual.toString()),
              ),
              Expanded(flex: 1, child: Text(tanggalfix)),
              Icon(
                Icons.delete_outline_outlined,
                size: 18,
                color: Colors.transparent,
              ),
              // IconButton(
              //     onPressed: () {
              //       showDialogDelete(
              //           context,
              //           "Apakah Anda yakin ingin menghapus data ini?",
              //           transaksi.idTransaksi!);
              //           // getTransaksi.

              //     },
              //     icon: Icon(
              //       Icons.delete_outline_outlined,
              //       size: 18,
              //       color: Colors.red,
              //     ))
            ],
          ),
        ),
      ),
    );
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
                Text(pesan, style: TextStyle(color: BaseTheme.color)),
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
}
