import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:simple_shadow/simple_shadow.dart';

TextStyle textStyle = GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w100, color: Colors.grey[100]);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  Map<String, dynamic>? pokemonData;
  String userId = "";
  String username = "";
  String password = "";

  Future<void> authenticate() async {
    final url = Uri.parse('http://127.0.0.1:5000/${isLogin ? "login" : "register"}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "password": password,
          if (!isLogin) "username": userId
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Navigator.pushReplacementNamed(context, '/');
      } else {
        debugPrint("Login failed: $response");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBodyBehindAppBar: true,
      body: Stack(fit: StackFit.expand, children: [
        Image.asset("assets/login-bg.jpg", fit: BoxFit.cover),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(color: Colors.black.withOpacity(0.6))
        ),
        Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.start ,children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: Center(child: SimpleShadow(sigma: 4, offset: const Offset(2, 6), child: Image.asset("assets/title.png", fit: BoxFit.cover)))
          ),
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start ,children: [
            if (!isLogin) ...[
              Text('Username', style: textStyle),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white70, width: 1),
                  color: Colors.black.withOpacity(0.2)
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white70,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (String text) {
                    setState(() => username = text);
                  }
                )
              ),
              const SizedBox(height: 16),
            ],
            Text('User ID', style: textStyle),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white70, width: 1),
                color: Colors.black.withOpacity(0.2)
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white70,
                decoration: const InputDecoration(
                  hintText: 'User ID',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.person_outline, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (String text) {
                  setState(() => userId = text);
                }
              )
            ),
            const SizedBox(height: 16),
            Text("Password", style: textStyle),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white70, width: 1),
                color: Colors.black.withOpacity(0.2)
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white70,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (String text) {
                  setState(() {
                    password = text;
                  });
                }
              )
            ),
            const SizedBox(height: 18),
            SizedBox(width: double.infinity, child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[500],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => authenticate(),
              child: Text(isLogin ? 'LOGIN' : 'REGISTER', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            )),
            // ),

            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(isLogin ? "No account?" : "Have an account?", style: textStyle),
              TextButton(
                onPressed: () {
                  setState(() =>isLogin = !isLogin);
                },
                child: Text(isLogin ? 'Register' : 'Login'),
              ),
              Text("Now!", style: textStyle)
            ])
          ])
        ]))
      ])
    );
  }
}