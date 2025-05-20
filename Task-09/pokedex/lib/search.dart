import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  List<dynamic> _allPokemons = [];
  List<dynamic> _filteredPokemons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  Future<void> _fetchPokemons() async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'); // Fetching first 151 Pokémon
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _allPokemons = data['results'];
          _filteredPokemons = _allPokemons; // Initially, show all Pokémon
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterPokemons(String query) {
    setState(() {
      _filteredPokemons = _allPokemons
          .where((pokemon) => pokemon['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Pokédex"), centerTitle: true),
        body: Column(
          children: <Widget>[
            SearchBar(onSearch: _filterPokemons), // Pass search function
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredPokemons.isEmpty
                  ? const Center(child: Text("No Pokémon found"))
                  : Grid(pokemons: _filteredPokemons),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;
  const SearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: "Search",
          hintText: "Search Pokémon by name",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: onSearch,
      ),
    );
  }
}

class Grid extends StatelessWidget {
  final List<dynamic> pokemons;
  const Grid({super.key, required this.pokemons});

  Future<Card> _addImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(
              color: Colors.black,
              width: 3.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              data['sprites']['other']['official-artwork']['front_default'],
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      throw Exception('Failed to load Pokémon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Card>(
          future: _addImage(pokemons[index]["url"]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Card(child: Center(child: Text("Failed to load")));
            } else {
              return snapshot.data ?? const Card(child: Text("No Data"));
            }
          },
        );
      },
    );
  }
}
