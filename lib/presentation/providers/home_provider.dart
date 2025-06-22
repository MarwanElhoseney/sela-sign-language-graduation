import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../../data/datasources/camera_data_source.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../domain/usecases/record_video_usecase.dart';
import '../../domain/usecases/send_video_usecase.dart';
import '../../domain/usecases/fetch_and_play_video_usecase.dart';

class HomeProvider extends ChangeNotifier {
  final _repository = VideoRepositoryImpl(CameraDataSource(), RemoteDataSource());
  late final RecordVideoUseCase _recordVideoUseCase;
  late final SendVideoUseCase _sendVideoUseCase;
  late final FetchAndPlayVideoUseCase _fetchAndPlayVideoUseCase;

  HomeProvider() {
    _recordVideoUseCase = RecordVideoUseCase(_repository);
    _sendVideoUseCase = SendVideoUseCase(_repository);
    _fetchAndPlayVideoUseCase = FetchAndPlayVideoUseCase(_repository);
    _init();
  }

  // State variables
  String selectedMode = "left";
  bool isLoading = false;
  String predictionResult = '';
  String fullSentence = '';
  int countdown = 0;
  int recordingCountdown = 0;
  List<CameraDescription>? cameras;
  int selectedTabIndex = 0;
  VideoPlayerController? videoController;
  bool isRightModeLoading = false;
  String rightModeError = '';
  String? currentImageUrl;
  late CameraController controller;

  Future<void> _init() async {
    cameras = await _repository.getAvailableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      await _repository.initializeCameraController(cameras![0], notifyListeners);
      controller = _repository.cameraController;
      notifyListeners();
    }
  }

  Future<void> switchCamera() async {
    if (cameras == null || cameras!.length < 2) return;
    _repository.dispose();
    _repository.selectedCameraIndex = (_repository.selectedCameraIndex + 1) % cameras!.length;
    await _repository.initializeCameraController(cameras![_repository.selectedCameraIndex], notifyListeners);
    controller = _repository.cameraController;
    notifyListeners();
  }

  Future<void> startRecordingProcess() async {
    if (isLoading || countdown > 0) return;
    for (int i = 3; i > 0; i--) {
      countdown = i;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
    }
    countdown = 0;
    notifyListeners();

    final video = await _recordVideoUseCase(const Duration(seconds: 5), (int rec) {
      recordingCountdown = rec;
      notifyListeners();
    });

    if (video != null) {
      isLoading = true;
      notifyListeners();
      await sendVideo(video);
    } else {
      predictionResult = "Failed to record video.";
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> sendVideo(File videoFile) async {
    predictionResult = "Sending video and processing...";
    notifyListeners();
    final prediction = await _sendVideoUseCase(videoFile);
    if (prediction == null || prediction.trim().isEmpty) {
      predictionResult = 'لم يتم اكتشاف أي إشارة، يرجى المحاولة مرة أخرى.';
    } else {
      if (fullSentence.isEmpty) {
        fullSentence = prediction;
      } else {
        fullSentence += ' $prediction';
      }
      predictionResult = prediction;
    }
    await _repository.speak(predictionResult);
    notifyListeners();
  }

  Future<void> fetchAndPlayVideo(String arabicSentence) async {
    final words = arabicSentence.trim().split(' ').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return;

    isRightModeLoading = true;
    rightModeError = '';
    currentImageUrl = null;
    videoController?.dispose();
    videoController = null;
    notifyListeners();

    bool wasPreviousDisplayAsImages = false;

    for (int i = 0; i < words.length; i++) {
      final word = words[i];

      if (wasPreviousDisplayAsImages) {
        await Future.delayed(const Duration(seconds: 1));
      }

      final url = Uri.parse('http://192.168.1.2:5001/video?word=${Uri.encodeComponent(word)}');

      try {
        final response = await HttpClient().getUrl(url).then((req) => req.close());
        if (response.statusCode == 200) {
          wasPreviousDisplayAsImages = false;
          final bytes = await consolidateHttpClientResponseBytes(response);
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/temp_video.mp4');
          await file.writeAsBytes(bytes);

          await videoController?.dispose();
          videoController = VideoPlayerController.file(file);
          await videoController!.initialize();

          currentImageUrl = null;
          if (i == 0) isRightModeLoading = false;
          videoController!.play();
          videoController!.setLooping(true);
          notifyListeners();

          await Future.delayed(const Duration(seconds: 5));
        } else {
          wasPreviousDisplayAsImages = true;
          if (i == 0) isRightModeLoading = false;
          notifyListeners();
          await _showCharacterImages(word);
        }
      } catch (e) {
        isRightModeLoading = false;
        rightModeError = 'Failed to connect to the server.';
        notifyListeners();
        return;
      }
    }

    await videoController?.dispose();
    videoController = null;
    isRightModeLoading = false;
    rightModeError = '';
    notifyListeners();
  }

  Future<void> _showCharacterImages(String word) async {
    final Map<String, int> arabicCharToId = {
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

    final characters = word.split('');
    for (final char in characters) {
      final letterId = arabicCharToId[char];
      if (letterId == null) {
        rightModeError = 'لا توجد صورة للحرف "$char"';
        currentImageUrl = null;
        notifyListeners();
        await Future.delayed(const Duration(seconds: 2));
        rightModeError = '';
        notifyListeners();
        continue;
      }
      final imageUrl = 'http://192.168.1.2:5002/get_letter_image/$letterId/0';

      currentImageUrl = imageUrl;
      videoController?.dispose();
      videoController = null;
      rightModeError = '';
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));
    }

    currentImageUrl = null;
    notifyListeners();
  }

  Future<void> speakSentence() async {
    if (fullSentence.isNotEmpty) {
      await _repository.speak(fullSentence);
    }
  }

  void resetSentence() {
    fullSentence = '';
    predictionResult = '';
    notifyListeners();
  }

  // Getters for UI
  int get selectedCameraIndex => _repository.selectedCameraIndex;

  CameraLensDirection? get currentCameraLensDirection {
    if (cameras != null && cameras!.isNotEmpty) {
      return cameras![selectedCameraIndex].lensDirection;
    }
    return null;
  }

  @override
  void dispose() {
    _repository.dispose();
    videoController?.dispose();
    super.dispose();
  }
}