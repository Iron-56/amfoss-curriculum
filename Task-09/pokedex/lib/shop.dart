import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  Map<String, dynamic>? pokemonData;

  @override
  void initState() {
    super.initState();
    fetchPokemon();
  }

  Future<void> fetchPokemon() async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/bulbasaur');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          pokemonData = data;
        });
      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(extendBodyBehindAppBar: true, body: Stack(fit: StackFit.expand, children: [

    ]));
  }
}
