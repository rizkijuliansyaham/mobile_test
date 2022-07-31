import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:test_qtasnim/utils/theme.dart';

class BottomBar extends StatefulWidget {
  final Function(int) selectedIndex;
  const BottomBar({required this.selectedIndex, Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.white,
        child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconBottomBar(
                          text: "Barang",
                          icon: Icons.list_alt_outlined,
                          selected: _selectedIndex == 0,
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                              widget.selectedIndex(0);
                            });
                          }),
                      IconBottomBar(
                          text: "Jenis",
                          icon: Icons.garage_outlined,
                          selected: _selectedIndex == 1,
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                              widget.selectedIndex(1);
                            });
                          }),
                      IconBottomBar2(
                          text: "Pay",
                          icon: Icons.compare_arrows_sharp,
                          selected: _selectedIndex == 2,
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 2;
                              widget.selectedIndex(2);
                            });
                          }),
                      IconBottomBar(
                          text: "Report",
                          icon: Icons.area_chart_outlined,
                          selected: _selectedIndex == 3,
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 3;
                              widget.selectedIndex(3);
                            });
                          }),
                      IconBottomBar(
                          text: "Info",
                          icon: Icons.info_outline,
                          selected: _selectedIndex == 4,
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 4;
                              widget.selectedIndex(4);
                            });
                          }),
                    ]))));
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon,
              size: 25,
              color:
                  selected ? BaseTheme.color : Colors.black.withOpacity(.75)),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 12,
              height: .1,
              color:
                  selected ? BaseTheme.color : Colors.black.withOpacity(.75)),
        )
      ],
    );
  }
}

class IconBottomBar2 extends StatelessWidget {
  const IconBottomBar2(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: BaseTheme.color,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
