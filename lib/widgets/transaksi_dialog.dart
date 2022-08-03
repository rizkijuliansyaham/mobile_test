import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/services/transaksi_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';

class TransaksiDialogAdd extends StatefulWidget {
  final List barang;
  final List jenis;
  final int id;
  const TransaksiDialogAdd(
      {Key? key, required this.id, required this.barang, required this.jenis})
      : super(key: key);

  @override
  State<TransaksiDialogAdd> createState() => _TransaksiDialogAddState();
}

class _TransaksiDialogAddState extends State<TransaksiDialogAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaBarang = TextEditingController();
  final TextEditingController jumlahTerjual = TextEditingController();
  late TextEditingController tanggal = TextEditingController();
  DateTime currentDate = DateTime.now();
  String? selectedValue;

  @override
  void initState() {
    DateTime currentDate = DateTime.now();
    var str = currentDate.toString();
    var arr = str.split(' ');
    tanggal = TextEditingController(text: arr[0]);

    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    var str = currentDate.toString();
    var arr = str.split(' ');
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        var str = currentDate.toString();
        var arr = str.split(' ');
        // print(arr[0]);
        tanggal = TextEditingController(text: arr[0]);
        // print(currentDate);
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
                      color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
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
                        'Pilih Barang',
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
                items: widget.barang
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
                    // print(selectedValue);
                    // print(widget.barang.indexOf('$selectedValue'));
                  });
                },
              )),
              // TextFormField(
              //   keyboardType: TextInputType.text,
              //   controller: namaBarang,
              //   decoration: InputDecoration(
              //       hintText: 'Contoh : Teh', labelText: 'Nama Barang'),
              //   validator: (value) {
              //     if (value!.isNotEmpty) {
              //       return null;
              //     } else {
              //       return "Harus diisi";
              //     }
              //   },
              // ),

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
                      enabled: false,
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
                      // print(currentDate);
                      // tanggal = currentDate.toString();
                    },
                    icon: Icon(Icons.date_range_outlined),
                    iconSize: 40,
                    color: BaseTheme.color,
                  ),
                ],
              )
            ],
          )),
      actions: [
        InkWell(
          onTap: (() {
            if (_formKey.currentState!.validate()) {
              // putStatusKontrolAuto(1, index);

              String nama_barang = selectedValue.toString();
              int jumlah_terjual = int.parse(jumlahTerjual.text.toString());
              String tanggal = currentDate.toString();
              List<String> tanggalSplit = tanggal.split(' ');
              String tanggal_transaksi = '${tanggalSplit[0]}';
              // print(tanggal_transaksi);
              int id_jenis = widget.jenis
                  .elementAt(widget.barang.indexOf('$selectedValue'));
              // putStatusKontrolParameter("$parameter", index);
              // print(id_jenis);
              TransaksiRepo.addTransaksi(widget.id, nama_barang, id_jenis,
                  jumlah_terjual, tanggal_transaksi);

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
