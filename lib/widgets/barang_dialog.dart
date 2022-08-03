import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/services/barang_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';

class BarangDialogAdd extends StatefulWidget {
  final List nama;
  final List idJenis;

  const BarangDialogAdd({Key? key, required this.nama, required this.idJenis})
      : super(key: key);

  @override
  State<BarangDialogAdd> createState() => _BarangDialogAddState();
}

class _BarangDialogAddState extends State<BarangDialogAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaBarang = TextEditingController();
  final TextEditingController stok = TextEditingController();
  String? selectedValue;

  @override
  void initState() {
    // widget.nama.map((e) {
    //   var str = e;
    //   var arr = str.split(',');
    //   var id = str[0];
    //   var jenisnya = str[1];
    // }).toList();
    // var str = data[index]['tanggal_transaksi'];
    //                         var arr = str.split('T');
    //                         var tanggal = arr[0].split('-');
    // TODO: implement initState
    super.initState();
  }

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
                items: widget.nama
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
                    print(selectedValue);
                    print(widget.nama.indexOf('$selectedValue'));
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
              int idJenisTerpilih = widget.idJenis
                  .elementAt(widget.nama.indexOf('$selectedValue'));

              BarangRepo.addBarang(nama_barang, stokAwal, idJenisTerpilih);

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

class BarangEdit extends StatelessWidget {
  final String namaBarang;
  final int stok;
  const BarangEdit({Key? key, required this.stok, required this.namaBarang})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController stokBaru = TextEditingController();
    final TextEditingController stokLama =
        TextEditingController(text: stok.toString());

    return AlertDialog(
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit Stok $namaBarang",
                  style: TextStyle(
                      color: BaseTheme.color, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              TextFormField(
                enabled: false,
                // keyboardType: TextInputType.number,
                controller: stokLama,
                decoration: InputDecoration(
                    hintText: 'Contoh : 12', labelText: 'Stok Lama'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: stokBaru,
                decoration: InputDecoration(
                    hintText: 'Contoh : 12', labelText: 'Stok Baru'),
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
            ],
          )),
      actions: [
        InkWell(
          onTap: (() {
            if (_formKey.currentState!.validate()) {
              int stok_baru = int.parse(stokBaru.text.toString());
              // String nama_barang = namaBarang.text.toString();
              // int stokAwal = int.parse(stok.text.toString());
              // int idJenisTerpilih = widget.idJenis
              //     .elementAt(widget.nama.indexOf('$selectedValue'));
              BarangRepo.editStokBarang(stok_baru, namaBarang);

              // BarangRepo.addBarang(nama_barang, stokAwal, idJenisTerpilih);

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
                "Update",
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
