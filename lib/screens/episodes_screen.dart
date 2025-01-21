import 'package:flutter/material.dart';
import 'package:group_project/models/episode_model.dart';
import 'package:group_project/models/tv_show_model.dart';
import 'package:group_project/services/api_services.dart';

class EpisodesScreen extends StatefulWidget {
  final int showId;
  const EpisodesScreen({super.key, required this.showId});

  @override
  _EpisodesScreenState createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  int selectedSeason = 1; 
  bool isSeasonsExpanded = false;
  late List<Episode> episodes;
  late int totalSeasons;
  late ShowDetails showDetails; 

  @override
  void initState() {
    super.initState();
    _loadEpisodes();
    _loadShowDetails();
  }

  Future<void> _loadShowDetails() async {
    final fetchedShow = await ApiService.getShowDetails(widget.showId);
    setState(() {
      showDetails = fetchedShow;
    });
  }

  Future<void> _loadEpisodes() async {
    final fetchedEpisodes = await ApiService.getShowEpisodes(widget.showId);
    setState(() {
      episodes = fetchedEpisodes;
      totalSeasons = getNumberOfSeasons(episodes);
    });
  }

  int getNumberOfSeasons(List<Episode> episodes) {
    return episodes.map((e) => e.season).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: FutureBuilder<List<Episode>>(
        future: ApiService.getShowEpisodes(widget.showId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No episodes available.'));
          } else {
            final episodes = snapshot.data!;
            final filteredEpisodes = episodes.where((episode) => episode.season == selectedSeason).toList();

            return Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showDetails.name, // Show title
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Episodes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.only(top: 80), 
                  itemCount: filteredEpisodes.length,
                  itemBuilder: (context, index) {
                    final episode = filteredEpisodes[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              episode.image.medium,
                              height: 100,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  episode.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${episode.runtime} min',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  episode.summary.replaceAll(RegExp(r'<[^>]*>'), ''),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isSeasonsExpanded = !isSeasonsExpanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Seasons',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            isSeasonsExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isSeasonsExpanded)
                  Positioned(
                    top: 50,
                    right: 10,
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.red,
                      child: SizedBox(
                        width: 150,
                        child: Column(
                          children: List.generate(totalSeasons, (index) {
                            int seasonNumber = index + 1;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSeason = seasonNumber;
                                  isSeasonsExpanded = false; 
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: Text(
                                  'Season $seasonNumber',
                                  style: TextStyle(
                                    color: selectedSeason == seasonNumber
                                        ? Colors.white
                                        : Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
      backgroundColor: const Color(0xFF273343),
    );
  }
}
