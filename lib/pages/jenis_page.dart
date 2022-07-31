import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class JenisPage extends StatefulWidget {
  const JenisPage({Key? key}) : super(key: key);

  @override
  State<JenisPage> createState() => _JenisPageState();
}

class _JenisPageState extends State<JenisPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Tes Ini jenis"),
    );
  }
}
