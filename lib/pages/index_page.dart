import 'package:flutter/material.dart';
import 'package:imh/pages/tabs/car_page.dart';
import 'package:imh/pages/tabs/check_in_page.dart';
import 'package:imh/pages/tabs/setting_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;

  final _carPageKey = GlobalKey<CarPageState>();
  final _checkInPageKey = GlobalKey<CheckInPageState>();

  late final List<Widget> _pages = [
    CarPage(key: _carPageKey),
    CheckInPage(key: _checkInPageKey),
    const SettingPage(),
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) {
      // Re-tap on selected tab: trigger refresh
      switch (index) {
        case 0:
          _carPageKey.currentState?.refresh();
        case 1:
          _checkInPageKey.currentState?.refresh();
      }
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            activeIcon: Icon(Icons.directions_car_rounded),
            label: '车辆',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl_outlined),
            activeIcon: Icon(Icons.checklist_rtl_rounded),
            label: '打卡',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings_rounded),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
