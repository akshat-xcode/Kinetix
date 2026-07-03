import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'camera_view.dart';
import 'game_view.dart';
import 'pose_detector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Force landscape mode for better game experience (optional, but let's stick to portrait for now to match front camera orientation)
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Human Joystick',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PlayerAction _currentAction = PlayerAction.none;

  void _handleActionDetected(PlayerAction action) {
    // Only update if action changed to avoid unnecessary rebuilds
    if (_currentAction != action) {
      setState(() {
        _currentAction = action;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Bottom Layer: Live Camera Feed
          CameraView(onActionDetected: _handleActionDetected),
          
          // 2. Top Layer: Game UI and Logic
          GameView(currentAction: _currentAction),
        ],
      ),
    );
  }
}
