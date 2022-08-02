import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/models/barang.dart';
import 'package:test_qtasnim/utils/theme.dart';

class BarangCard extends StatelessWidget {
  final BarangModel barang;
  const BarangCard({Key? key, required this.barang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        height: 50,
        // color: Colors.blueAccent,
        decoration: BoxDecoration(
            border: Border.all(color: BaseTheme.abu, width: 2),
            // color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: ,
            children: [
              Text(barang.namaBarang.toString()),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Text('Stok : ${barang.stok.toString()}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
