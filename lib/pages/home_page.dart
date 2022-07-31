import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/models/barang.dart';
import 'package:test_qtasnim/pages/barang_page.dart';
import 'package:test_qtasnim/pages/info_page.dart';
import 'package:test_qtasnim/pages/jenis_page.dart';
import 'package:test_qtasnim/pages/report_page.dart';
import 'package:test_qtasnim/pages/transaksi_page.dart';
import 'package:test_qtasnim/widgets/bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: _selectedIndex == 0
            ? BarangPage()
            : _selectedIndex == 1
                ? JenisPage()
                : _selectedIndex == 2
                    ? TransaksiPage()
                    : _selectedIndex == 3
                        ? ReportPage()
                        : _selectedIndex == 4
                            ? InfoApps()
                            : Container(),
      )),
      bottomNavigationBar: BottomBar(selectedIndex: (i) {
        // change the page according to the index
        // uncomment in case you want to implement more pages and make sure
        // to create a _selectedIndex variable

        setState(() {
          _selectedIndex = i;
        });
      }),
    );
  }
}
