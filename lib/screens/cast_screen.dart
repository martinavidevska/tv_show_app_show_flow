import 'package:flutter/material.dart';
import 'package:group_project/models/actor_model.dart';
import 'package:group_project/services/api_services.dart';
import 'package:group_project/widgets/actor_card.dart';

class CastScreen extends StatefulWidget {
  final int showId;
  final String showName;

  const CastScreen({Key? key, required this.showId, required this.showName})
      : super(key: key);

  @override
  _CastScreenState createState() => _CastScreenState();
}

class _CastScreenState extends State<CastScreen> {
  List<Actor> cast = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> _loadCast() async {
    try {
      final fetchedCast = await ApiService.getShowCast(widget.showId);
      setState(() {
        print(fetchedCast);
        cast = fetchedCast;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = "Failed to load cast. Please try again.";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF273343),
      appBar: AppBar(
      backgroundColor: const Color(0xFF273343),
      iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
               height: 40,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.showName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Cast',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: cast.length,
                            itemBuilder: (context, index) {
                              final actor = cast[index];
                              return ActorCard(actor: actor);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          
    );
  }
}
