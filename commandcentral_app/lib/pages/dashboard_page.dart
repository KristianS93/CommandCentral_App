import 'package:flutter/material.dart';
import 'package:commandcentral_app/pages/grocerylist_page.dart';
import 'package:commandcentral_app/pages/mealplanner_page.dart';
import 'package:commandcentral_app/components/custom_colors.dart';
import 'package:commandcentral_app/components/menubar.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    Center(
      child: Text(
        'Hi, Welcome back!',
        style: TextStyle(fontSize: 24),
      ),
    ),
    GroceryListPage(),
    MealPlannerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: loginBgColor,
      appBar: AppBar(
        title: Text(_getAppBarTitle(_currentPageIndex)),
        backgroundColor: appItemColor,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomMenuBar(
        currentIndex: _currentPageIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Grocery List';
      case 2:
        return 'Meal Planner';
      default:
        return 'Dashboard';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
