import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:CareTalk/frontend/main_screens/call_log_collection.dart';
import 'package:CareTalk/frontend/main_screens/chat_and_Status.dart';
import 'package:CareTalk/frontend/main_screens/friends/friends.dart';
import 'package:CareTalk/frontend/main_screens/settings.dart';
import 'package:CareTalk/global_uses/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0; //current tab index
  PageController _pageController = PageController();
  final List<Widget> pageViews = [
    const ChatAndStatusScreen(),
    const FriendsScreen(),
    const CallLogCollection(),
    const SettingsWindow(),
  ];

  // //to check if user is online or not
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);

  //   final isBg = state == AppLifecycleState.paused;
  //   final isClosed = state == AppLifecycleState.detached;
  //   final isScreen = state == AppLifecycleState.resumed;

  //   isBg || isScreen == true || isClosed == false
  //       ? setState(() {
  //           // SET ONLINE
          
  //         })
  //       : setState(() {
  //           //SET  OFFLINE
          
  //         });
  // }

  @override
  void initState() {  
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex > 0) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          bottomNavigationBar: _bottomNavigation(),
          backgroundColor: kWhite,
          body: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: pageViews,
            ),
          )),
    );
  }

  Widget _bottomNavigation() {
    return SlidingClippedNavBar.colorful(
      backgroundColor: kWhite,
      onButtonPressed: (index) {
        setState(() {
          _currentIndex = index;
        });
        _pageController.animateToPage(_currentIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuad);
      },
      iconSize: 25,
      fontSize: 15,
      selectedIndex: _currentIndex,
      barItems: [
        BarItem(
          icon: Icons.message_rounded,
          title: 'Messages',
          activeColor: kSecondaryAppColor, // Colors.blue,
          inactiveColor: kPrimaryAppColor,
        ),
        BarItem(
          icon: Icons.people,
          title: 'Contacts',
          activeColor: kSecondaryAppColor,//Colors.red,
          inactiveColor: kPrimaryAppColor,// Colors.green,
        ),
        BarItem(
          icon: Icons.phone,
          title: 'Calls',
          activeColor: kSecondaryAppColor, //Colors.amber,
          inactiveColor: kPrimaryAppColor, // Colors.red,
        ),
        BarItem(
          icon: Icons.settings,
          title: 'Settings',
          activeColor: kSecondaryAppColor, // Colors.blue,
          inactiveColor: kPrimaryAppColor,// Colors.teal,
        ),
      ],
    );
  }
}