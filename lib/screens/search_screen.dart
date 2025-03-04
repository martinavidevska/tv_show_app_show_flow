import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_project/models/tv_show_model.dart';
import 'package:group_project/services/api_services.dart';
import 'package:group_project/widgets/tv_show_grid.dart';

class SearchTvShowScreen extends StatefulWidget {
  const SearchTvShowScreen({super.key});

  @override
  _SearchTvShowScreenState createState() => _SearchTvShowScreenState();
}

class _SearchTvShowScreenState extends State<SearchTvShowScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;
  List<ShowDetails> _searchResults = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        _searchShows(query);
      } else {
        setState(() {
          _searchResults.clear();
        });
      }
    });
  }

  Future<void> _searchShows(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await ApiService.searchShow(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF273343),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search Shows',
                hintText: 'Enter show name',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                labelStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? TVShowGrid(shows: _searchResults)
                : const Center(
                    child: Text('No results found. Start searching!'),
                  ),
          ),
        ],
      ),
    );
  }
}
