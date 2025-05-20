import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? pokemonData;


  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await authenticate();
    await fetchPokemon();
  }

  Future<void> authenticate() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    final url = Uri.parse('http://127.0.0.1:5000/verify');

    if (token == null || token.isEmpty) {
      Navigator.pushNamed(context, "/login");
      return;
    }

    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        return;
      } else {
        debugPrint("Invalid token: $response.body");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }

    Navigator.pushNamed(context, "/login");
  }

  Future<void> fetchPokemon() async {
    try {
      final url = Uri.parse('http://127.0.0.1:5000/captured');
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      var response = await http.get(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        List<String> captured = List<String>.from(jsonDecode(response.body));
        response = await http.get(Uri.parse('http://127.0.0.1:5000/pokemon/${captured[0]}'));
        setState(() {
          if (response.statusCode == 200) {
            final Map<String, dynamic> data = jsonDecode(response.body);
            pokemonData = data;
          }
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
    return Scaffold(extendBodyBehindAppBar: true, body: Stack(fit: StackFit.expand, children: [
      Image.asset("assets/bg.jpg", fit: BoxFit.cover),
      Padding(padding: const EdgeInsets.all(12.0), child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Image.asset("assets/coin.png", height: 42),
                const Text("244", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))
              ]),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.black,
                )
              )
            ])
          ),

          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(child: imageContainer(imagePath: "assets/person.png"),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            Expanded(child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Row(children: [
                Expanded(child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black54
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Row(children: List.generate(10, (index) {
                    return Container(
                      width: 10,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.yellow[700],
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    );
                  })))
                )),

                const SizedBox(width: 10),
                Image.asset("assets/pokeball.png", width: 40),
              ]),
            )),
            GestureDetector(child: imageContainer(imagePath: "assets/settings.png"),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        )
        ]),
        Column(children: [
          ClipRRect(borderRadius: BorderRadius.circular(5),
            child: pokemonData == null ? const CircularProgressIndicator() : SimpleShadow(
              sigma: 7,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: Image.network(pokemonData!['sprites']['other']['official-artwork']['front_default'], fit: BoxFit.contain),
              ),
            )
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/browse');
            },
            child: itemContainer(
              w: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.travel_explore, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Browse", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              )
            )
          )
        ]),
        const SizedBox()
      ]))
    ]));
  }

  Widget imageContainer({required String imagePath}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Image.asset(imagePath),
    );
  }

  Widget itemContainer({required Widget w}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        border: Border.all(
            color: Colors.black38,
            width: 2
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: w
    );
  }
}
