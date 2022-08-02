import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/models/barang.dart';
import 'package:test_qtasnim/pages/barang_page.dart';
import 'package:test_qtasnim/pages/info_page.dart';
import 'package:test_qtasnim/pages/search_page.dart';
import 'package:test_qtasnim/pages/report_page.dart';
import 'package:test_qtasnim/pages/transaksi_page.dart';
import 'package:test_qtasnim/widgets/bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: _selectedIndex == 0
            ? BarangPage()
            // : _selectedIndex == 1
            //     ? SearchPage()
            : _selectedIndex == 1
                ? TransaksiPage()
                : _selectedIndex == 2
                    ? ReportPage()
                    // : _selectedIndex == 4
                    //     ? InfoApps()
                    : Container(),
      )),
      bottomNavigationBar: BottomBar(selectedIndex: (i) {
        setState(() {
          _selectedIndex = i;
        });
      }),
    );
  }
}
