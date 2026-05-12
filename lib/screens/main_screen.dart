import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/common/app_bottom_bar.dart';
import 'home_screen.dart';
import 'tourist_cities_screen.dart';
import 'travel_tips_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  final GlobalKey<TouristCitiesScreenState> _citiesKey =
      GlobalKey<TouristCitiesScreenState>();
  final GlobalKey<TravelTipsScreenState> _tipsKey =
      GlobalKey<TravelTipsScreenState>();

  late final List<Widget> _pages = [
    const HomeScreen(),
    TouristCitiesScreen(key: _citiesKey),
    TravelTipsScreen(key: _tipsKey),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void setSelectedIndex(int index) {
    if (_selectedIndex == index) return;

    final previousIndex = _selectedIndex;
    setState(() {
      _selectedIndex = index;
    });

    if ((previousIndex - index).abs() == 1) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    _pageController.jumpToPage(index);
  }

  bool _handleBack() {
    if (_selectedIndex == 1 && (_citiesKey.currentState?.handleBack() ?? false)) {
      return true;
    }

    if (_selectedIndex == 2 && (_tipsKey.currentState?.handleBack() ?? false)) {
      return true;
    }

    if (_selectedIndex != 0) {
      setSelectedIndex(0);
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!_handleBack()) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: AppBottomBar(
          selectedIndex: _selectedIndex,
          onTabSelected: setSelectedIndex,
        ),
      ),
    );
  }
}
