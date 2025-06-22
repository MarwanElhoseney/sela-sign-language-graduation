import 'dart:io';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';

abstract class VideoRepository {
  Future<List<CameraDescription>> getAvailableCameras();
  Future<void> initializeCameraController(CameraDescription camera, Function listener);
  CameraController get cameraController;
  int get selectedCameraIndex;
  set selectedCameraIndex(int index);
  Future<File?> recordVideo(Duration duration, Function(int) onCountdown);
  Future<String?> sendVideo(File videoFile);
  Future<void> speak(String message);
  Future<VideoPlayerController?> fetchAndPlayVideo(String word, Function(String?) onImage, Function(String) onError);
  void dispose();
}