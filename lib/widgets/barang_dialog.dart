import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/utils/theme.dart';

class BarangDialogAdd extends StatefulWidget {
  final List a;
  const BarangDialogAdd({Key? key, required this.a}) : super(key: key);

  @override
  State<BarangDialogAdd> createState() => _BarangDialogAddState();
}

class _BarangDialogAddState extends State<BarangDialogAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaBarang = TextEditingController();
  final TextEditingController stok = TextEditingController();
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tambah Barang",
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
                controller: stok,
                decoration:
                    InputDecoration(hintText: 'Contoh : 12', labelText: 'Stok'),
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
              DropdownButtonHideUnderline(
                  child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: widget.a
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
              ))
            ],
          )),
      actions: [
        InkWell(
          onTap: (() {
            if (_formKey.currentState!.validate()) {
              String nama_barang = namaBarang.text.toString();
              int stokAwal = int.parse(stok.text.toString());

              // BarangRepo.addBarang(nama_barang, stokAwal, id_jenis)

              // putStatusKontrolParameter("$parameter", index);
              // TransaksiRepo.addTransaksi(
              //     id, nama_barang, jumlah_terjual, tanggal_transaksi);

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
