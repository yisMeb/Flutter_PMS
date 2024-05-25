import 'package:flutter/material.dart';
import 'package:pmanager/Pages/Dashboards/CreateProject.dart';
import 'package:pmanager/Pages/Dashboards/HomePage.dart'; // Import CreateProject class

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              _buildPage(0),
              _buildPage(1),
              Container(),
              _buildPage(3),
              _buildPage(4),
            ],
          ),
          if (_selectedIndex == 2)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: CreateProject(),
                ),
              ),
            ),
          if (_selectedIndex == 0)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: HomePage(),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Color.fromARGB(200, 54, 52, 163),
              size: 60.0,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildPage(int index) {
    return Center(
      child: Text(
        "Page $index",
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
