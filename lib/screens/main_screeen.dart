import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/screens/favourite_shows_screen.dart';
import 'package:group_project/screens/home_screen.dart';
import 'package:group_project/screens/login_screen.dart';
import 'package:group_project/screens/profile_screen.dart';
import 'package:group_project/screens/search_screen.dart';
import 'package:group_project/widgets/bottom-navbar.dart';
import 'package:provider/provider.dart';
import 'package:group_project/providers/tv_show_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final provider = Provider.of<TVShowProvider>(context, listen: false);
    provider.loadShowsAndFavorites();
  }

  void _onNavBarTap(int index) async {
    if (index == 3) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        if (FirebaseAuth.instance.currentUser != null) {
          setState(() {
            _currentIndex = 3;
          });
        }
      } else {
        setState(() {
          _currentIndex = 3;
        });
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TVShowProvider>(context);

    final List<Widget> screens = [
      HomeScreen(),
      const SearchTvShowScreen(),
      const FavoriteScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF273343),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
