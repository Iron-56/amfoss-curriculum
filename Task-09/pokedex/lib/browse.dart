import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Browse extends StatefulWidget {
  const Browse({super.key});

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {

  List<dynamic> _filteredPokemons = [];
  List<dynamic> _capturedPokemons = [];
  List<dynamic> friendsData = [];
  List<Map<String, dynamic>> _pokemonDetails = [];
  List<dynamic> _allTypes = [];
  String searchedPokemonName = "";
  String _selectedType = "All";
  bool _isLoading = true;

  int _minHp = 0;
  int _minAttack = 0;
  int _minDefense = 0;
  int _maxHp = 200;
  int _maxAttack = 200;
  int _maxDefense = 200;

  String _selectedUserId = "";
  String _selectedPokemonId = "";

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
    _fetchTypes();
    getFriends();
  }

  void newTrade() async {
    if (_selectedUserId.isNotEmpty) {
      final url = Uri.parse('http://127.0.0.1:5000/trade');
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
          body: jsonEncode({
            "friendId": _selectedUserId,
            "pokeId": _selectedPokemonId
          })
        );
        if (response.statusCode == 200) {
          // Navigator.pop(context);
          Navigator.pushNamed(context, "/");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trade successful!')),
          );
        } else {
          Navigator.pushNamed(context, "/");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.body)),
          );
          throw Exception('Failed to trade ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching data: $e');
      }
    }
  }

  String getTitle(String s) {
    return s.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  Widget buildFriendTile(Map<String, dynamic> friend) {
    return GestureDetector(
        onTap: () {
          setState(() => _selectedUserId = friend["friend_id"]);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: _selectedUserId == friend["friend_id"] ? Colors.blue[800]?.withOpacity(0.7) : Colors.blue[400]?.withOpacity(0.7),
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
            ])
          ]),
        )
    );
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

  Color getTypeColor(String type) {
    switch (type) {
      case 'normal':
        return Colors.grey;
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'electric':
        return Colors.amber;
      case 'grass':
        return Colors.green;
      case 'ice':
        return Colors.cyanAccent;
      case 'fighting':
        return Colors.deepOrange;
      case 'poison':
        return Colors.purpleAccent;
      case 'ground':
        return Colors.brown;
      case 'flying':
        return Colors.indigoAccent;
      case 'psychic':
        return Colors.pinkAccent;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Colors.brown[300]!;
      case 'ghost':
        return Colors.deepPurple;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black87;
      case 'steel':
        return Colors.blueGrey;
      case 'fairy':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void showTradeDialog() {
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
            Text("Trade to a Friend", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              ...friendsData.map((f) => GestureDetector(
                onTap: () {
                  setModalState(() {
                    _selectedUserId = f["friend_id"];
                  });
                  setState(() {
                    _selectedUserId = f["friend_id"];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: _selectedUserId == f["friend_id"] ? Colors.blue[800]?.withOpacity(0.7) : Colors.blue[400]?.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(2, 2))]
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      const Icon(Icons.person_outline, size: 30, color: Colors.white),
                      const SizedBox(width: 10),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(f["name"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[200])),
                        Text(f["friend_id"], style: TextStyle(fontSize: 12, color: Colors.grey[400]),),
                      ]),
                    ])
                  ]),
                )
              )), // Convert map to list
            ]);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: (){
              newTrade();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Trade"),
          )
        ],
      ),
    );
  }


  Future<Container> _addImage(Map<String, dynamic> data) async {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue[800]?.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue[900]!, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 4))],
        ),
        child:Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children:[
            SizedBox(width: 148, child: Column(children: [
              SimpleShadow(sigma: 2, child: Image.network(data['sprites']['other']['official-artwork']['front_default'])),
              SizedBox(
                width: double.infinity,
                child: _capturedPokemons.contains(data['id'].toString()) ? ElevatedButton(
                  onPressed: (){
                    _selectedPokemonId = data["id"].toString();
                    showTradeDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Trade"),
                ) : const SizedBox(),
              )
            ])),

            Expanded(child: Column(children: [
              Text(getTitle(data["name"]),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pokemon',
                  fontSize: 30,
                  letterSpacing: 3,
                  color: Colors.yellow[700],
                  shadows: [Shadow(offset: const Offset(2, 2), blurRadius: 4, color: Colors.blue[900]!)],
                ),
              ),

              const SizedBox(height: 4),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var typeInfo in data['types'])
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Chip(
                      label: Text(
                          getTitle(typeInfo['type']['name']),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                      side: BorderSide.none,
                      backgroundColor: getTypeColor(typeInfo['type']['name'])
                  )),
              ]),

              const SizedBox(height: 8),

              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Column(children: [
                  SizedBox(height: 30, child: Image.asset("assets/hp.png")),
                  Text(data['stats'][0]['base_stat'].toString(),
                    style: TextStyle(
                      fontFamily: "Courier",
                      fontSize: 24,
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
                Column(children: [
                  SizedBox(height: 30, child: Image.asset("assets/attack.png")),
                  Text(data['stats'][1]['base_stat'].toString(),
                    style: TextStyle(
                      fontFamily: "Courier",
                      fontSize: 24,
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
                Column(children: [
                  SizedBox(height: 30, child: Image.asset("assets/shield.png")),
                  Text(data['stats'][2]['base_stat'].toString(),
                    style: TextStyle(
                      fontFamily: "Courier",
                      fontSize: 24,
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ])
              ])
            ]))
          ]),
        ])
    );
  }

  Widget _buildSlider(String img, RangeValues values, Function(RangeValues) onChanged) {
    return Row(children: [
      SizedBox(width: 36, child: Image.asset(img)),
      RangeSlider(
          values: values,
          min: 0,
          max: 200,
          divisions: 20,
          labels: RangeLabels(values.start.round().toString(), values.end.round().toString()),
          onChanged: onChanged
      )
    ]);
  }

  Widget categoryType(String type, {bool selected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _applyFilters();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.blue[900]!.withOpacity(0.4) : Colors.blue[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? Colors.grey[200]! : Colors.white, width: 2),
          boxShadow: [BoxShadow(
            color: selected ? Colors.black.withOpacity(0.1) : Colors.black.withOpacity(0.3),
            blurRadius: selected ? 2 : 4,
            offset: const Offset(2, 4),
          )],
        ),
        child: Text(type, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }


  Widget searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[800]?.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue[900]!, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(2, 2))],
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: 'Search Pokémon...',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        onSubmitted: _filterPokemons,
      ),
    );
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        RangeValues tempHp = RangeValues(_minHp.toDouble(), _maxHp.toDouble());
        RangeValues tempAttack = RangeValues(_minAttack.toDouble(), _maxAttack.toDouble());
        RangeValues tempDefense = RangeValues(_minDefense.toDouble(), _maxDefense.toDouble());

        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: Colors.blue[800],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Filter by Stats", style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSlider("assets/hp.png", tempHp, (range) {
                    setModalState(() => tempHp = range);
                  }),
                  _buildSlider("assets/attack.png", tempAttack, (range) {
                    setModalState(() => tempAttack = range);
                  }),
                  _buildSlider("assets/shield.png", tempDefense, (range) {
                    setModalState(() => tempDefense = range);
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _minHp = tempHp.start.toInt();
                      _maxHp = tempHp.end.toInt();
                      _minAttack = tempAttack.start.toInt();
                      _maxAttack = tempAttack.end.toInt();
                      _minDefense = tempDefense.start.toInt();
                      _maxDefense = tempDefense.end.toInt();
                    });
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: const Text("Apply"),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _applyFilters() {
    final result = _pokemonDetails.where((data) {
      int hp = data['stats'][0]['base_stat'];
      int attack = data['stats'][1]['base_stat'];
      int defense = data['stats'][2]['base_stat'];
      final name = data['name'];

      final types = (data['types'] as List).map((typeInfo) => getTitle(typeInfo['type']['name'])).toList();

      return (hp >= _minHp && hp <= _maxHp) &&
          (attack >= _minAttack && attack <= _maxAttack) &&
          (defense >= _minDefense && defense <= _maxDefense) &&
          name.contains(searchedPokemonName.toLowerCase()) &&
          (_selectedType == "All" || types.contains(_selectedType) || (_selectedType == "Captured" && _capturedPokemons.contains(data['id'].toString())));
    }).toList();

    setState(() {
      _filteredPokemons = result;
    });
  }

  Future<void> _fetchTypes() async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/type/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() => _allTypes = data['results']);
      } else {
        throw Exception('Failed to load types list');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() => _isLoading = false);
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
        List<dynamic> allPokemons = data['results'];
        _capturedPokemons = data['captured'];

        final details = await Future.wait(
            allPokemons.map((pokemon) async {
              try {
                final res = await http.get(Uri.parse(pokemon['url']));
                if (res.statusCode == 200) return jsonDecode(res.body);
              } catch (_) {}
              return null;
            })
        );

        _pokemonDetails = details.whereType<Map<String, dynamic>>().toList();

        setState(() {
          _filteredPokemons = _pokemonDetails;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load Pokemon list');
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
      searchedPokemonName = query;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            extendBodyBehindAppBar: true,
            body: Stack(fit: StackFit.expand, children: [
              Image.asset("assets/bg.jpg", fit: BoxFit.cover),
              Column(children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16), child: Column(children: [
                  Row(children: [
                    GestureDetector(child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.blue[800]?.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blue[900]!, width: 2),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(2, 2))]
                        ),
                        child: SizedBox(height: 24, child: Image.asset("assets/arrow.png"))
                    ), onTap: () => Navigator.pushNamed(context, '/')),
                    const SizedBox(width: 12),
                    Expanded(child: searchBar()),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _openFilterDialog,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.blue[800]?.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blue[900]!, width: 2),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(2, 2))]
                        ),
                        child: SizedBox(height: 24, child: Image.asset("assets/filter.png")),
                      ),
                    )
                  ]),
                  const SizedBox(height: 12),
                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                    categoryType("All", selected: _selectedType == "All"),
                    const SizedBox(width: 12),
                    categoryType("Captured", selected: _selectedType == "Captured"),
                    const SizedBox(width: 12),
                    ..._allTypes.map((type) => Row(
                      children: [
                        categoryType(getTitle(type["name"]), selected: _selectedType == getTitle(type["name"])),
                        const SizedBox(width: 12),
                      ],
                    )),
                  ]))


                ])),
                Expanded(child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredPokemons.isEmpty
                    ? Center(child: Text("No Pokemon found", style: TextStyle(fontFamily: "Courier", fontSize: 28, color: Colors.grey[100], fontWeight: FontWeight.normal))) : ListView.separated(
                    padding: const EdgeInsets.all(10),
                    separatorBuilder: (context, index) {return const SizedBox(height: 20);},
                    itemCount: _filteredPokemons.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<Container>(
                          future: _addImage(_filteredPokemons[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(child: Text("Failed to load"));
                            } else {
                              return snapshot.data ?? const Text("No Data");
                            }
                          }
                      );
                    }
                )
                )
              ])
            ])
        )
    );
  }
}