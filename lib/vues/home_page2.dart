import 'package:flutter/material.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/colors.dart';
import 'package:groupe_des_vainqueurs/vues/testimony_page.dart';
import 'package:groupe_des_vainqueurs/vues/theme_prayer_page.dart';
import 'package:groupe_des_vainqueurs/vues/topicality_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  late TextStyle optionStyle;
  late List<Widget> tabBarViewItem;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    optionStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: <Widget>[
          Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const <Widget>[
                  Tab(
                    text: "actualité",
                  ),
                  Tab(
                    text: "Témoignages",
                  ),
                  Tab(
                    text: "Thème de priere",
                  ),
                ],
                indicatorColor: Colors.orange[900],
                labelColor: Colors.orange[900],
                unselectedLabelColor: Colors.blueGrey,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                TopicalityPage(),
                TestimonyPage(),
                PrayerThemePage(),
                // ListView.builder(
                // itemCount:
                //     actualites[TypeActualite.toutes]?.length ?? 0,
                // itemBuilder: (context, i) => PostContainer(
                //     actualite: actualites[TypeActualite.toutes]![i])),
              ],
            ),
          ),
          Text(
            'Index 1: notification',
            style: optionStyle,
          ),
          Text(
            'Index 2: sujets',
            style: optionStyle,
          ),
        ].elementAt(_selectedIndex),
      ),
    );
  }
}
