import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/presentation/pages/componyProfile/company_profile.dart';
import 'package:tax_app/presentation/pages/employee/employee_list.dart';
import 'package:tax_app/presentation/pages/homePage/home_screen.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int currentInde = 0;
  void changeIndex(int index) {
    setState(() {
      currentInde = index;
    });
  }

  List<Widget> screens = const [
    HomeScreen(),
    EmployeeList(),
    CompanyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentInde,
        onTap: changeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            activeIcon: Icon(
              Icons.home,
              color: DemozColors.primaryBlue,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_sharp),
            label: 'Home',
            activeIcon: Icon(
              Icons.view_list_sharp,
              color: DemozColors.primaryBlue,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp),
            label: 'Home',
            activeIcon: Icon(
              Icons.person_outline_sharp,
              color: DemozColors.primaryBlue,
            ),
          ),
        ],
      ),
      body: screens[currentInde],
    );
  }
}
