import 'package:flutter/material.dart';
import 'package:group_project/models/tv_show_model.dart';
import 'package:group_project/screens/favourite_shows_screen.dart';
import 'package:group_project/screens/home_screen.dart';
import 'package:group_project/screens/search_screen.dart';
import 'package:group_project/services/api_services.dart';
import 'package:group_project/widgets/bottom-navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late Future<List<ShowDetails>> _shows;

  @override
  void initState() {
    super.initState();
    _shows = fetchTVShows();
  }

  Future<List<ShowDetails>> fetchTVShows() async {
    final showsData = await ApiService.getShowByIndex(200);
    showsData.sort((a, b) => (b.weight ?? 0).compareTo(a.weight ?? 0));
    return showsData;
  }

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF273343),
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        title: Row(
          children: [
           Image.asset(
              'assets/images/logo.png',
               height: 40,
      ),
            const SizedBox(width: 10),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); 
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ShowDetails>>(
        future: _shows,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final shows = snapshot.data!;
            final List<Widget> _screens = [
              TVShowList(shows: shows),  
              const SearchTvShowScreen(),
              FavoriteScreen()
            ];
            return _screens[_currentIndex];
          } else {
            return const Center(child: Text("No TV shows available"));
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
