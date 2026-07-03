import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pose_detector.dart';

class GameView extends StatefulWidget {
  final PlayerAction currentAction;

  const GameView({Key? key, required this.currentAction}) : super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _playerY = 0; // -1 to 1 (-1 is jump, 1 is duck)
  
  // Game logic
  double _obstacleX = 1.5; // Starts offscreen right
  double _obstacleY = 0.8; // Ground level obstacle
  int _score = 0;
  bool _gameOver = false;
  
  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    if (_gameOver) return;

    setState(() {
      // Update player position based on action
      if (widget.currentAction == PlayerAction.jump) {
        _playerY = -0.8;
      } else if (widget.currentAction == PlayerAction.duck) {
        _playerY = 0.8;
      } else {
        // Gravity / return to center slowly
        _playerY = _playerY * 0.8;
      }

      // Move obstacle
      _obstacleX -= 0.02;

      // Obstacle reset
      if (_obstacleX < -1.5) {
        _obstacleX = 1.5;
        _score += 10;
        // Randomize next obstacle position (high or low)
        _obstacleY = Random().nextBool() ? 0.8 : -0.2;
      }

      // Collision detection (very basic bounding box in normalized coordinates)
      // Player is at X = -0.5
      if ((_obstacleX - (-0.5)).abs() < 0.2) {
        if ((_playerY - _obstacleY).abs() < 0.3) {
          _gameOver = true;
        }
      }
    });
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _obstacleX = 1.5;
      _gameOver = false;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Premium Dark Gradient Overlay to make the camera feed darker
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.deepPurple.withOpacity(0.6),
              ],
            ),
          ),
        ),
        
        // Player
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment(-0.5, _playerY),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.8),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: const Icon(Icons.accessibility_new, color: Colors.black, size: 40),
          ),
        ),

        // Obstacle
        Container(
          alignment: Alignment(_obstacleX, _obstacleY),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.8),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ],
            ),
            child: const Icon(Icons.warning, color: Colors.white),
          ),
        ),

        // UI Layer (Score)
        Positioned(
          top: 60,
          left: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Text(
                  'SCORE: $_score',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Game Over Screen
        if (_gameOver)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'GAME OVER',
                        style: GoogleFonts.orbitron(
                          color: Colors.pinkAccent,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            const Shadow(color: Colors.pinkAccent, blurRadius: 20)
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Final Score: $_score',
                        style: GoogleFonts.orbitron(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: _restartGame,
                        child: Text(
                          'PLAY AGAIN',
                          style: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
