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
              //
            ],
          ),
        ),
      ),
    );
  }
}
