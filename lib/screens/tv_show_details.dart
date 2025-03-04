import 'package:flutter/material.dart';
import 'package:group_project/screens/cast_screen.dart';
import 'package:group_project/screens/episodes_screen.dart';
import 'package:group_project/services/api_services.dart';
import 'package:group_project/widgets/details_row.dart';
import 'package:group_project/widgets/genre_container.dart';
import 'package:provider/provider.dart';
import '../models/tv_show_model.dart';
import '../providers/tv_show_provider.dart';

class ShowDetailsScreen extends StatefulWidget {
  final int showId;

  const ShowDetailsScreen({super.key, required this.showId});

  @override
  State<ShowDetailsScreen> createState() => _ShowDetailsScreenState();
}

class _ShowDetailsScreenState extends State<ShowDetailsScreen> {
  late Future<ShowDetails> _showDetails;

  @override
  void initState() {
    super.initState();
    _showDetails = fetchShowDetails(widget.showId);
  }

  Future<ShowDetails> fetchShowDetails(int id) async {
    final response = ApiService.getShowDetails(id);
    return response;
  }

  void _toggleFavorite(ShowDetails show) {
    final provider = Provider.of<TVShowProvider>(context, listen: false);
    provider.toggleFavorite(show);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.favoriteIds.contains(show.id)
            ? 'Added to favorites!'
            : 'Removed from favorites'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TVShowProvider>(context);

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
      body: FutureBuilder<ShowDetails>(
        future: _showDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final show = snapshot.data!;
            final isFavorite = provider.favoriteIds.contains(show.id);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      show.image?.original != null
                          ? Image.network(
                              show.image!.original!,
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: double.infinity,
                              height: 300,
                              color: Colors.grey,
                              child: const Center(child: Text('No Image')),
                            ),
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                show.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '★ ${show.rating?.average ?? "NA"} / 10',
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      cleanSummary(show.summary),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: show.genres
                                  ?.map((genre) => GenreContainer(genre: genre))
                                  .toList() ??
                              [],
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        const SizedBox(height: 8),
                        DetailsRow(
                          label: 'Premiered:',
                          value: show.premiered ?? 'N/A',
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        DetailsRow(
                          label: 'Status:',
                          value: show.status ?? 'N/A',
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        DetailsRow(
                          label: 'Language:',
                          value: show.language ?? 'N/A',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => _toggleFavorite(show),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CastScreen(
                                  showId: show.id,
                                  showName: show.name,
                                ),
                              ),
                            );
                          },
                          label: const Text('Cast'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EpisodesScreen(showId: show.id),
                              ),
                            );
                          },
                          label: const Text('Episodes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No show details found"));
          }
        },
      ),
    );
  }
}

String cleanSummary(String? htmlSummary) {
  if (htmlSummary == null) return 'No summary available.';
  return htmlSummary.replaceAll(RegExp(r'<[^>]*>'), '');
}
