import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simple_shadow/simple_shadow.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String username = "";
  String userId = "";
  List<dynamic> friendsData = [];
  List<dynamic> _capturedPokemons = [];
  List<dynamic> _tradeRequests = [];
  List<dynamic> _tradePokemons = [];
  bool _isLoading = true;
  String tradeOut = "";
  String choseCaption = "Select a pokemon to request";

  final TextEditingController userIdController = TextEditingController();

  Future<void> _fetchTrades() async {
    try {
      final url = Uri.parse('http://127.0.0.1:5000/trade');
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final List<dynamic> trades = jsonDecode(response.body);
        setState(() => _tradeRequests = trades);

        final List<Map<String, dynamic>> detailedTrades = await Future.wait(trades.map((trade) async {
          final tradeOutId = trade['tradeOut'];
          final tradeForId = trade['tradeFor'];

          final tradeOutResponse = await http.get(Uri.parse('http://127.0.0.1:5000/pokemon/$tradeOutId'));
          final tradeForResponse = await http.get(Uri.parse('http://127.0.0.1:5000/pokemon/$tradeForId'));

          final tradeOutData = jsonDecode(tradeOutResponse.body);
          final tradeForData = jsonDecode(tradeForResponse.body);

          return {
            'friendId': trade['friendId'],
            'tradeOut': tradeOutData,
            'tradeFor': tradeForData,
          };
        }));

        setState(() => _tradePokemons = detailedTrades);
        // debugPrint(detailedTrades[0]['friendId']+detailedTrades[0]['tradeOut']+detailedTrades[0]['tradeFor']);
        // debugPrint(_tradePokemons.toString());

      } else {
        throw Exception('Failed to load trades');
      }
    } catch (e) {
      debugPrint('Error fetching trades: $e');
    }
  }

  Future<void> _fetchPokemons() async {
    try {
      final url = Uri.parse('http://127.0.0.1:5000/pokemons');
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final response = await http.get(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> capturedPokemonIds = data['captured'];

        final details = await Future.wait(
            capturedPokemonIds.map((pokemon) async {
              try {
                final res = await http.get(Uri.parse('http://127.0.0.1:5000/pokemon/$pokemon'));
                if (res.statusCode == 200) return jsonDecode(res.body);
              } catch (_) {}
              return null;
            })
        );
        setState(() {
          _capturedPokemons = details.where((d) => d != null).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load Pokemon list');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> getUserDetails() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');

      if (token == null) return;

      final payload = token.split('.')[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final userIdFromToken = json.decode(decoded)['sub'];
      userId = userIdFromToken;

      final url = Uri.parse('http://127.0.0.1:5000/about/$userId');
      final response = await http.get(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        dynamic userData = jsonDecode(response.body);
        setState(() => username = userData['name']);
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> getFriends() async {
    try {
      final url = Uri.parse('http://127.0.0.1:5000/friends');
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      final response = await http.get(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        setState(() => friendsData = jsonDecode(response.body));
      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  String getTitle(String s) {
    return s.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void logout() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
    Navigator.pushNamed(context, "/login");
  }

  void addFriend() async {
    final userId = userIdController.text.trim();

    if (userId.isNotEmpty) {
      final url = Uri.parse('http://127.0.0.1:5000/friend/$userId');
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      try {
        final response = await http.post(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'});
        if (response.statusCode == 200) {
          dynamic data = jsonDecode(response.body);
          setState(() => friendsData.add({"name" : data["name"].toString(), "friend_id": userId}));
          userIdController.clear();
        } else {
          throw Exception('Failed to add friend');
        }
      } catch (e) {
        debugPrint('Error fetching data: $e');
      }
    }
  }

  void acceptTrade() async {

  }

  void newTrade() async {
    final userId = userIdController.text.trim();

    if (userId.isNotEmpty) {
      final url = Uri.parse('http://127.0.0.1:5000/friend/$userId');
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      try {
        final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
            body: jsonEncode({})
        );
        if (response.statusCode == 200) {
        } else {
          throw Exception('Failed to add trade');
        }
      } catch (e) {
        debugPrint('Error fetching data: $e');
      }
    }
  }

  Widget buildTradeTile(Map<String, dynamic> trade) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[800]?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildPokemonColumn("Offered", trade["tradeOut"]),
          const Icon(Icons.swap_horiz, color: Colors.white),
          _buildPokemonColumn("Requested", trade["tradeFor"]),
        ]),
         ElevatedButton(
          onPressed: acceptTrade,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Trade"),
        )
      ])
    );
  }

  Widget _buildPokemonColumn(String label, dynamic pokemon) {
    return Column(
      children: [
        Image.network(pokemon['sprites']['other']['official-artwork']['front_default'], height: 70),
        const SizedBox(height: 6),
        Text(
          getTitle(pokemon["name"]),
          style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget buildFriendTile(Map<String, dynamic> friend) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[800]?.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(2, 2))]
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          const Icon(Icons.person_outline, size: 30, color: Colors.white),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(friend["name"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[200])),
            Text(friend["friend_id"], style: TextStyle(fontSize: 12, color: Colors.grey[400]),),
          ]),
        ]),
        ElevatedButton(
          onPressed: (){
            selectPokemonDialog(friend["friend_id"]);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Trade"),
        )
      ]),
    );
  }

  void selectPokemonDialog(String id) {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF2C2F3E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.redAccent, width: 2)),
      title: Row(children: [
        const Icon(Icons.catching_pokemon, color: Colors.redAccent),
        const SizedBox(width: 8),
        Column(children: [
          const Text("Select a Pokemon", style: TextStyle(color: Colors.white)),
          Text(choseCaption, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ])
      ]),
      content: SizedBox(width: 300, height: 400, child: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.separated(
        padding: const EdgeInsets.all(10),
        separatorBuilder: (context, index) {return const SizedBox(height: 20);},
        itemCount: _capturedPokemons.length,
        itemBuilder: (context, index) {
          final pokemon = _capturedPokemons[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () async {
                final selectedPokemon = pokemon["id"];
                if (tradeOut == "") {
                  setState(() {
                    tradeOut = selectedPokemon.toString();
                    choseCaption = "Select a Pokemon to offer";
                  });
                } else {
                  Navigator.pop(context);

                  final url = Uri.parse('http://127.0.0.1:5000/trade');
                  final preferences = await SharedPreferences.getInstance();
                  final token = preferences.getString('token');

                  final response = await http.post(
                    url,
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token'
                    },
                    body: jsonEncode({
                      "friendId": id,
                      "tradeOut": tradeOut,
                      "tradeFor": selectedPokemon
                    }),
                  );

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Trade request sent!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green)
                    );
                    _fetchTrades();
                    setState(() {
                      tradeOut = "";
                      choseCaption = "Select a pokemon to request";
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Trade request failed.", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[800]?.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue[900]!, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 4))],
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  SizedBox(
                    width: 148,
                    child: SimpleShadow(
                      sigma: 2,
                      child: Image.network(pokemon['sprites']['other']['official-artwork']['front_default']),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    getTitle(pokemon["name"]),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Pokemon',
                      fontSize: 30,
                      letterSpacing: 3,
                      color: Colors.yellow[700],
                      shadows: [Shadow(offset: const Offset(2, 2), blurRadius: 4, color: Colors.blue[900]!)],
                    ),
                  ),
                ]),
              )
            ),
          );
        })
      )
    ));
  }

  void showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2F3E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        title: const Row(
          children: [
            Icon(Icons.catching_pokemon, color: Colors.redAccent),
            SizedBox(width: 8),
            Text("Add a Friend", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userIdController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "User ID",
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white38),
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              addFriend();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text("Add", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    _fetchTrades();
    _fetchPokemons();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/bg.jpg", fit: BoxFit.cover),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Image.asset("assets/person.png", height: 60),
                    const SizedBox(width: 10),
                    Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text("ID: $userId", style: const TextStyle(fontSize: 14, color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () => logout()
                        ),
                      ]),

                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      )
                    ]))
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text("Your Friends", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    IconButton(
                      onPressed: showAddFriendDialog,
                      icon: const Icon(Icons.person_add),
                      color: Colors.white,
                    ),
                  ]),
                  ...friendsData.map((f) => buildFriendTile(f)),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("Trade Requests",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ..._tradePokemons.map((t) => buildTradeTile(t)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
