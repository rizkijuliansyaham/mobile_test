import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/services/transaksi_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';

class TransaksiDialogAdd extends StatefulWidget {
  final List a;
  final int id;
  const TransaksiDialogAdd({Key? key, required this.id, required this.a})
      : super(key: key);

  @override
  State<TransaksiDialogAdd> createState() => _TransaksiDialogAddState();
}

class _TransaksiDialogAddState extends State<TransaksiDialogAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaBarang = TextEditingController();
  final TextEditingController jumlahTerjual = TextEditingController();
  late TextEditingController tanggal =
      TextEditingController(text: currentDate.toString());
  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        tanggal = TextEditingController(text: currentDate.toString());
        print(currentDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tambah Transaksi",
                  style: TextStyle(
                      color: BaseTheme.color, fontWeight: FontWeight.bold)),
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
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: tanggal,
                      decoration: InputDecoration(
                          hintText: '2022-02-01', labelText: 'Tanggal'),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "Harus diisi";
                        }
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _selectDate(context);
                        print(currentDate);
                        // tanggal = currentDate.toString();
                      },
                      icon: Icon(Icons.date_range_outlined)),
                ],
              )
            ],
          )),
      actions: [
        InkWell(
          onTap: (() {
            if (_formKey.currentState!.validate()) {
              // putStatusKontrolAuto(1, index);
              int id_transaksi = widget.id + 1;

              String nama_barang = namaBarang.text.toString();
              int jumlah_terjual = int.parse(jumlahTerjual.text.toString());
              String tanggal = currentDate.toString();
              List<String> tanggalSplit = tanggal.split(' ');
              String tanggal_transaksi = '${tanggalSplit[0]}';
              print(tanggal_transaksi);
              // putStatusKontrolParameter("$parameter", index);
              TransaksiRepo.addTransaksi(
                  widget.id, nama_barang, jumlah_terjual, tanggal_transaksi);

              Navigator.of(context).pop();
            }
          }),
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                color: BaseTheme.color, borderRadius: BorderRadius.circular(4)),
            child: Center(
              child: Text(
                "Tambah",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }
}
