import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

void main() {
  runApp(CardMatchGameApp());
}

class CardType {
  final String imagePath;
  bool isPicked;
  bool isGone;

  CardType(
      {required this.imagePath, this.isPicked = false, this.isGone = false});
}

class CardMatchGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Karim\'s Card Match Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DifficultyScreen(),
    );
  }
}

class DifficultyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[300],
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/cards.svg',
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                ),
                Text(
                  'Welcome to Karim\'s Match Game!!!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.birthstone(
                    fontSize: 80,
                    color: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              'Please Choose the Difficulty:',
              textAlign: TextAlign.center,
              style: GoogleFonts.galada(
                fontSize: 40,
                color: Colors.grey[100],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: SizedBox(
              width: 350,
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(fontSize: 35),
                  backgroundColor: Colors.teal[700],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardMatchGameScreen(gridSize: 4),
                    ),
                  );
                },
                child: Text(
                  'Standard (4x4)',
                  style: GoogleFonts.fugazOne(
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: 350,
              height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(fontSize: 35),
                  backgroundColor: Colors.teal[700],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardMatchGameScreen(gridSize: 6),
                    ),
                  );
                },
                child: Text(
                  'Difficult (6x6)',
                  style: GoogleFonts.fugazOne(
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CardMatchGameScreen extends StatefulWidget {
  final int gridSize;
  CardMatchGameScreen({required this.gridSize});

  @override
  _CardMatchGameScreenState createState() => _CardMatchGameScreenState();
}

class _CardMatchGameScreenState extends State<CardMatchGameScreen> {
  late List<CardType> cards;
  int numberOfMoves = 0;
  int? firstPickIndex;
  int? secondPickIndex;

  @override
  void initState() {
    super.initState();
    initializeCards();
  }

  void initializeCards() {
    List<String> image_paths = [
      'assets/images/1.webp',
      'assets/images/2.webp',
      'assets/images/3.webp',
      'assets/images/4.webp',
      'assets/images/5.webp',
      'assets/images/6.webp',
      'assets/images/7.webp',
      'assets/images/8.webp',
      'assets/images/9.webp',
      'assets/images/10.webp',
      'assets/images/11.webp',
      'assets/images/12.webp',
      'assets/images/13.webp',
      'assets/images/14.webp',
      'assets/images/15.webp',
      'assets/images/16.webp',
      'assets/images/17.webp',
      'assets/images/18.webp',
    ];

    cards = [];
    int gameSize = widget.gridSize * widget.gridSize;
    int pairCount = (gameSize) ~/ 2;

    for (int cardNumber = 1; cardNumber <= pairCount; cardNumber++) {
      cards.add(
          CardType(imagePath: image_paths[cardNumber % image_paths.length]));
      cards.add(
          CardType(imagePath: image_paths[cardNumber % image_paths.length]));
    }

    cards.shuffle(Random());
  }

  bool isValidPick(int index) {
    return index >= 0 &&
        index < cards.length &&
        !cards[index].isGone &&
        !cards[index].isPicked;
  }

  bool isGameOver() {
    return cards.every((card) => card.isGone);
  }

  void handleCardTap(int index) {
    setState(() {
      if (!isValidPick(index)) return;

      if (firstPickIndex == null) {
        firstPickIndex = index;
        cards[firstPickIndex!].isPicked = true;
      } else if (secondPickIndex == null) {
        secondPickIndex = index;
        cards[secondPickIndex!].isPicked = true;
        numberOfMoves++;

        if (cards[firstPickIndex!].imagePath ==
            cards[secondPickIndex!].imagePath) {
          cards[firstPickIndex!].isGone = true;
          cards[secondPickIndex!].isGone = true;
        } else {
          setState(() {
            cards[firstPickIndex!].isPicked = false;
            cards[secondPickIndex!].isPicked = false;
          });
        }

        firstPickIndex = null;
        secondPickIndex = null;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Container(
          alignment: Alignment.center,
        ),
      ),
      body: Container(
        color: Colors.teal[300],
        padding: EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.gridSize,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 436 / 565,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => handleCardTap(index),
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: cards[index].isGone
                              ? Colors.transparent
                              : cards[index].isPicked
                                  ? Colors.white
                                  : Colors.transparent,
                        ),
                        child: cards[index].isGone
                            ? Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/check-mark.webp'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : cards[index].isPicked
                                ? Image.asset(cards[index].imagePath,
                                    fit: BoxFit.contain)
                                : Image.asset('assets/images/card-back.webp',
                                    fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isGameOver()) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Congratulations! You have completed this round in $numberOfMoves moves.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lobster(
                        fontSize: 25,
                        color: Colors.grey[100],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        width: 200,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            textStyle: TextStyle(fontSize: 25),
                            backgroundColor: Colors.teal[700],
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DifficultyScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Play Again',
                            style: GoogleFonts.fugazOne(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
