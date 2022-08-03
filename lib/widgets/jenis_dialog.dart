import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/models/jenis.dart';
import 'package:test_qtasnim/services/jenis_repo.dart';
import 'package:test_qtasnim/utils/theme.dart';

class AddJeniss extends StatefulWidget {
  final int id;

  final Future<List<JenisModel>> getJenis;
  const AddJeniss({Key? key, required this.id, required this.getJenis})
      : super(key: key);

  @override
  State<AddJeniss> createState() => _AddJenissState();
}

class _AddJenissState extends State<AddJeniss> {
  late Future<List<JenisModel>> jenis;

  @override
  void initState() {
    // TODO: implement initState
    jenis = widget.getJenis;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController namaJenis = TextEditingController();
    return AlertDialog(
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tambah Jenis",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: namaJenis,
                decoration: InputDecoration(
                    hintText: 'Contoh : Pembersih', labelText: 'Nama Jenis'),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return "Harus diisi";
                  }
                },
              ),
            ],
          )),
      actions: [
        InkWell(
          onTap: (() {
            if (_formKey.currentState!.validate()) {
              String jenis_barang = namaJenis.text.toString();
              JenisRepo.addJenis(widget.id, jenis_barang);
              setState(() {
                jenis = JenisRepo().getJenis();
              });
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
                "Tambah Jenis",
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

class AddJenis extends StatelessWidget {
  final int id;
  const AddJenis({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(id);
    final _formKey = GlobalKey<FormState>();
    final TextEditingController namaJenis = TextEditingController();
    return AlertDialog(
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tambah Jenis",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: namaJenis,
                decoration: InputDecoration(
                    hintText: 'Contoh : Pembersih', labelText: 'Nama Jenis'),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return "Harus diisi";
                  }
                },
              ),
            ],
          )),
      actions: [
        InkWell(
          onTap: (() {
            if (_formKey.currentState!.validate()) {
              String jenis_barang = namaJenis.text.toString();
              JenisRepo.addJenis(id, jenis_barang);
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
                "Tambah Jenis",
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
