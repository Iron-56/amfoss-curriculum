import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SilhouetteGame extends StatefulWidget {
  const SilhouetteGame({super.key});

  @override
  State<SilhouetteGame> createState() => _SilhouetteGameState();
}

class _SilhouetteGameState extends State<SilhouetteGame> {
  int seconds = 10;
  Timer? countdownTimer;
  String? token;
  int? silhouetteId;
  bool hasGuessed = false;
  bool? guessCorrect;
  String? correctPokemonName;
  String guessedPokemon = "";

  @override
  void initState() {
    super.initState();
    getToken();
    getSilhouette();
  }

  Future<void> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }

  void resetGame() {
    setState(() {
      seconds = 50;
      hasGuessed = false;
      guessCorrect = null;
      correctPokemonName = null;
      guessedPokemon = "";
      silhouetteId = null;
    });
    getSilhouette();
  }


  void showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2F3E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        title: Text(
          guessCorrect == true ? "Correct!" : "Wrong!",
          style: TextStyle(
            color: guessCorrect == true ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "The correct Pokemon was: ${correctPokemonName ?? 'Unknown'}",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: const Text("Continue", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }


  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        timer.cancel();
        if (!hasGuessed) {
          submitSilhouetteGuess();
        }
      }
    });
  }

  void stopTimer() {
    countdownTimer?.cancel();
  }


  Future<void> getSilhouette() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    var res = await http.get(Uri.parse('http://127.0.0.1:5000/silhouette'), headers: {"Authorization": "Bearer $token"},);

    if (res.statusCode == 200) {
      setState(() {
        silhouetteId = silhouetteId = jsonDecode(res.body)["pokemon"];
        seconds = 50;
        startTimer();
      });
    } else {
      debugPrint("Error fetching silhouette ${res.statusCode}");
    }
  }

  Future<void> submitSilhouetteGuess() async {
    final res = await http.post(
      Uri.parse('http://127.0.0.1:5000/silhouette/$guessedPokemon'),
      headers: {"Authorization": "Bearer $token"},
    );

    stopTimer();

    if (res.statusCode == 200 || res.statusCode == 208) {
      setState(() => guessCorrect = true);
    } else {
      setState(() => guessCorrect = false);
    }

    hasGuessed = true;
    correctPokemonName = res.body;
    showResultDialog();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  Widget itemContainer({required String text}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(fit: StackFit.expand, children: [
        Image.asset("assets/bg.jpg", fit: BoxFit.cover),
        Padding(padding: const EdgeInsets.all(12), child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[800]?.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue[900]!, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(2, 2))],
                ),
                child: Image.asset("assets/arrow.png", height: 24),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withAlpha(120),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(children: [
                Text("$seconds", style: TextStyle(color: Colors.red[500], fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                Icon(Icons.access_time_rounded, color: Colors.grey[400])
              ])
            ),
          ]),
          Center(child: Padding(
            padding: const EdgeInsets.all(50),
            child: silhouetteId != null ? Image.network(
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$silhouetteId.png",
              height: 350,
              color: (!hasGuessed && seconds > 0) ? Colors.black : null,
              colorBlendMode: (!hasGuessed && seconds > 0) ? BlendMode.srcIn : null,
            ) : const CircularProgressIndicator()
          )),
          Padding(padding: const EdgeInsets.all(10.0), child: Column(children: [
            Container(
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
                  labelText: 'Guess Pokémon name',
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.pets, color: Colors.white),
                  border: InputBorder.none,
                ),
                onChanged: (text) => guessedPokemon = text,
              )
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                submitSilhouetteGuess();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text('GUESS!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            )
          ]))
        ]))
      ]),
    );
  }
}
