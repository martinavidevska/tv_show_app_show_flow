import 'package:flutter/material.dart';
import 'package:group_project/providers/tv_show_provider.dart';
import 'package:provider/provider.dart';
import 'package:group_project/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TVShowProvider>(context, listen: false).fetchUserData());
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<TVShowProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF273343),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: userProvider.isLoading
            ? const CircularProgressIndicator() 
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userProvider.profilePictureUrl != null
                        ? NetworkImage(userProvider
                            .profilePictureUrl!) 
                        : const AssetImage('assets/images/default_avatar.jpg')
                            as ImageProvider, 
                    backgroundColor: Colors.grey[800],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Welcome, ${userProvider.name ?? 'Loading...'}!",
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Email: ${userProvider.email ?? 'Loading...'}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await AuthService().logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text("Logout"),
                  ),
                ],
              ),
      ),
    );
  }
}
