import 'package:flutter/material.dart';
import 'package:objectbox_demo/screens/HomePage.dart';
import 'package:objectbox_demo/screens/OrderListPage.dart';

class BottomTabsWrapper extends StatefulWidget {
  const BottomTabsWrapper({Key? key}) : super(key: key);

  @override
  State<BottomTabsWrapper> createState() => _BottomTabsWrapperState();
}

class _BottomTabsWrapperState extends State<BottomTabsWrapper> {
  int currentIndex = 0;
  List<Widget> kTabs = const [HomePage(), OrderListPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kTabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              debugPrint(value.toString());
              currentIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Orders",
            ),
          ]),
    );
  }
}
