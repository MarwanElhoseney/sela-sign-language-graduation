import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/camera_data_source.dart';
import '../datasources/remote_data_source.dart';
import 'package:path_provider/path_provider.dart';

const Map<String, int> arabicCharToId = {
  'ا': 0, 'أ': 0, 'إ': 0, 'آ': 0,
  'ب': 1,
  'ت': 2, 'ة': 2,
  'ث': 3,
  'ج': 4,
  'ح': 5,
  'خ': 6,
  'د': 7,
  'ذ': 8,
  'ر': 9,
  'ز': 10,
  'س': 11,
  'ش': 12,
  'ص': 13,
  'ض': 14,
  'ط': 15,
  'ظ': 16,
  'ع': 17,
  'غ': 18,
  'ف': 19,
  'ق': 20,
  'ك': 21,
  'ل': 22,
  'م': 23,
  'ن': 24,
  'ه': 25,
  'و': 26,
  'ي': 27, 'ى': 27,
};

class VideoRepositoryImpl implements VideoRepository {
  final CameraDataSource cameraDataSource;
  final RemoteDataSource remoteDataSource;
  final FlutterTts flutterTts = FlutterTts();

  List<CameraDescription>? _cameras;
  late CameraController _controller;
  int _selectedCameraIndex = 0;

  VideoRepositoryImpl(this.cameraDataSource, this.remoteDataSource);

  @override
  Future<List<CameraDescription>> getAvailableCameras() async {
    _cameras = await cameraDataSource.getAvailableCameras();
    return _cameras!;
  }

  @override
  Future<void> initializeCameraController(CameraDescription camera, Function listener) async {
    _controller = CameraController(camera, ResolutionPreset.high, enableAudio: false);
    _controller.addListener(() => listener());
    await _controller.initialize();
  }

  @override
  CameraController get cameraController => _controller;

  @override
  int get selectedCameraIndex => _selectedCameraIndex;

  @override
  set selectedCameraIndex(int index) {
    _selectedCameraIndex = index;
  }

  @override
  Future<File?> recordVideo(Duration duration, Function(int) onCountdown) async {
    if (!_controller.value.isInitialized || _controller.value.isRecordingVideo) {
      return null;
    }
    try {
      final Directory extDir = await getTemporaryDirectory();
      await Directory('${extDir.path}/Videos').create(recursive: true);
      await _controller.startVideoRecording();

      for (int i = duration.inSeconds; i > 0; i--) {
        onCountdown(i);
        await Future.delayed(const Duration(seconds: 1));
      }
      onCountdown(0);

      if (!_controller.value.isRecordingVideo) {
        return null;
      }
      final XFile videoFile = await _controller.stopVideoRecording();
      return File(videoFile.path);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> sendVideo(File videoFile) async {
    return await remoteDataSource.sendVideoToServer(videoFile);
  }

  @override
  Future<void> speak(String message) async {
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.speak(message);
  }

  @override
  Future<VideoPlayerController?> fetchAndPlayVideo(
      String word,
      Function(String?) onImage,
      Function(String) onError,
      ) async {
    final words = word.trim().split(' ').where((w) => w.isNotEmpty).toList();
    for (final w in words) {
      final file = await remoteDataSource.fetchVideoFromServer(w);
      if (file != null) {
        final controller = VideoPlayerController.file(file);
        await controller.initialize();
        controller.play();
        controller.setLooping(true);
        return controller;
      } else {
        // Show character images
        for (final char in w.split('')) {
          final letterId = arabicCharToId[char];
          if (letterId == null) {
            onError('لا توجد صورة للحرف "$char"');
            await Future.delayed(const Duration(seconds: 2));
            onError('');
            continue;
          }
          final imageUrl = await remoteDataSource.getLetterImage(letterId);
          onImage(imageUrl);
          await Future.delayed(const Duration(seconds: 2));
        }
        onImage(null);
      }
    }
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
  }
}