import 'package:flutter/material.dart';

// Import your GroceryListPage and MealPlannerPage here
import 'package:commandcentral_app/pages/grocerylist_page.dart';
import 'package:commandcentral_app/pages/mealplanner_page.dart';
// import 'package:commandcentral_app/components/dashboardcontent.dart';
import 'package:commandcentral_app/components/menubar.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          Center(
            child: Text(
              'Hi, Welcome back!',
              style: TextStyle(fontSize: 24),
            ),
          ),
          GroceryListPage(),
          MealPlannerPage(),
        ],
      ),
      bottomNavigationBar: BottomMenuBar(
        currentIndex: _currentPageIndex,
        onTap: _onItemTapped,
      ),
    );
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
