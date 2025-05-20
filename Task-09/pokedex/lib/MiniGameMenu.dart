import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class MiniGameMenu extends StatefulWidget {
  const MiniGameMenu({super.key});

  @override
  State<MiniGameMenu> createState() => _MiniGameMenuState();
}

class _MiniGameMenuState extends State<MiniGameMenu> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> games = [
    {"image": "assets/silhouette.png", "name": "Silhouette Game", "route":"/silhouette"},
    {"image": "assets/quiz.png", "name": "Quiz Game", "route":"/quiz"}
  ];

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _nextPage() {
    if (_currentPage < games.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/bg.jpg", fit: BoxFit.cover),
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[800]?.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue[900]!, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(2, 2))]
              ),
              child: Image.asset("assets/arrow.png", height: 24)),
              onTap: () => Navigator.pop(context),
            )
          ),
          Column(
            children: [
              const SizedBox(height: 60),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: games.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Center(
                            // child: SizedBox(
                              child: SimpleShadow(
                                opacity: 0.3,
                                color: Colors.black,
                                offset: const Offset(5, 5),
                                sigma: 5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(games[index]["image"]!, fit: BoxFit.contain),
                                ),
                              ),
                            // ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Image.asset("assets/arrow.png", height: 24),
                            onPressed: _previousPage,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            icon: const Icon(Icons.play_arrow, color: Colors.white),
                            label: const Text("Play", style: TextStyle(color: Colors.white, fontSize: 16)),
                            onPressed: () {
                              Navigator.pushNamed(context, games[_currentPage]['route']!);
                            },
                          ),
                          IconButton(
                            icon: Transform(
                              transform: Matrix4.identity()..scale(-1.0, 1.0),
                              alignment: Alignment.center,
                              child: Image.asset("assets/arrow.png", height: 24),
                            ),
                            onPressed: _nextPage,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
