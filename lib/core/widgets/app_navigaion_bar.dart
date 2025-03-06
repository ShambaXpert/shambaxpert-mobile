import 'package:agro_scan/features/image-analysis/presentation/pages/home_page.dart';
import 'package:agro_scan/features/image-analysis/presentation/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppNavigaionBar extends StatefulWidget {
  const AppNavigaionBar({super.key});

  @override
  State<AppNavigaionBar> createState() => _AppNavigaionBarState();
}

class _AppNavigaionBarState extends State<AppNavigaionBar> {
  int _selectedIndex = 0;

  final List<Widget> pages = [const HomePage(), const SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: "settings",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() => _selectedIndex = value),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
