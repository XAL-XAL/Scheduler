import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/view/calendar_page.dart';
import 'package:scheduler/view/directory_page.dart';
import 'package:scheduler/view/profile_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class BottomMenuBar extends StatefulWidget {
  const BottomMenuBar({Key? key}) : super(key: key);

  @override
  State<BottomMenuBar> createState() => _BottomMenuBarState();
}

class _BottomMenuBarState extends State<BottomMenuBar> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: [
            CalendarPage(),
            DirectoryPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            title: Text('Calendar'),
            icon: Icon(Icons.calendar_today),
          ),
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            title: Text('Directory'),
            icon: Icon(Icons.groups_rounded),
          ),
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            title: Text('Profile'),
            icon: Icon(Icons.face_sharp),
          ),
        ],
      ),
    );
  }
}
