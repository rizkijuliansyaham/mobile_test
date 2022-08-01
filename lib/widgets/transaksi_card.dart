import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/models/transaksi_model.dart';

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
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(flex: 1, child: Text(transaksi.namaBarang.toString())),
              Expanded(
                flex: 1,
                child: Text(transaksi.jumlahTerjual.toString()),
              ),
              Expanded(flex: 1, child: Text(tanggalfix)),
              IconButton(
                  onPressed: () {
                    // deleteDataTransaksi(
                    //     data[index]['id_transaksi']);
                    // showDialogDelete(
                    //     context,
                    //     "Apakah Anda yakin ingin menghapus data ini?",
                    //     data[index]['id_transaksi']);
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
  }
}
