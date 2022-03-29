import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:scuba/screens/adminMainScreen.dart';
import 'package:scuba/screens/calculMainScreen.dart';
import 'package:scuba/screens/profileMainScreen.dart';
import 'package:scuba/screens/tableListScreen.dart';
import 'homeScreen.dart';

BuildContext? testContext;

/*
* Gestionnaire de la navigation globale de l'application
*/

class NavigationScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  const NavigationScreen({Key? key, required this.menuScreenContext})
      : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  late PersistentTabController _controller;
  late bool _hideNavBar;

  //Initialisation de la page
  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  //Items & écrans principaux
  List<Widget> _buildScreens() {
    return [
      HomeScreen(
        menuScreenContext: widget.menuScreenContext,
        hideStatus: _hideNavBar,
        onVisitePage: () {
          setState(() {
            _hideNavBar = !_hideNavBar;
          });
        },
      ),
      const ProfileMainScreen(),
      const CalculMainScreen(),
      const TableListScreen(),
      const AdminMainScreen(),
    ];
  }

  //Style de la bottomNavBar
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Accueil",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle),
        title: ("Profil"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => TableListScreen(),
            '/second': (context) => const ProfileMainScreen(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calculate_rounded),
        title: ("Calcul"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => const TableListScreen(),
            '/second': (context) => const ProfileMainScreen(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.table_rows_rounded),
        title: ("Tables"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => const ProfileMainScreen(),
            '/second': (context) => const ProfileMainScreen(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: ("Paramètres"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: {
            '/first': (context) => const ProfileMainScreen(),
            '/second': (context) => const ProfileMainScreen(),
          },
        ),
      ),
    ];
  }

  //Fonctionnalités de la navBar
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PersistentTabView(
        context!,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: false,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        selectedTabScreenContext: (context) {
          testContext = context;
        },
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style8,
        decoration: const NavBarDecoration(
          colorBehindNavBar: Colors.indigo,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
        ),
      ),
    );
  }
}
//12, neuno,11,8,6,5
