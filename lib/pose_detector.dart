import 'dart:ui';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum PlayerAction { none, jump, duck }

class PoseDetectorController {
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());

  // Thresholds to determine jumping and ducking based on Y coordinate differences.
  // These will need to be calibrated but serve as a baseline.
  double? _baselineY;
  
  void dispose() {
    _poseDetector.close();
  }

  Future<PlayerAction> processImage(InputImage inputImage) async {
    try {
      final poses = await _poseDetector.processImage(inputImage);
      if (poses.isEmpty) return PlayerAction.none;

      final pose = poses.first;
      
      // Get the landmarks for nose and shoulders
      final nose = pose.landmarks[PoseLandmarkType.nose];
      final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
      final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

      if (nose != null && leftShoulder != null && rightShoulder != null) {
        double currentY = nose.y;

        // Establish a baseline if not set
        if (_baselineY == null) {
          _baselineY = currentY;
          return PlayerAction.none;
        }

        // Calculate the difference from the baseline
        double diff = currentY - _baselineY!;

        // Adjust baseline slowly towards current Y to account for camera movement
        _baselineY = _baselineY! * 0.95 + currentY * 0.05;

        // If nose goes up significantly (y decreases in image coordinates)
        if (diff < -60) {
          return PlayerAction.jump;
        } 
        // If nose goes down significantly (y increases)
        else if (diff > 80) {
          return PlayerAction.duck;
        }
      }
      return PlayerAction.none;
    } catch (e) {
      print('Error processing pose: $e');
      return PlayerAction.none;
    }
  }
}
