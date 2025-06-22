import 'dart:io';
import '../repositories/video_repository.dart';

class RecordVideoUseCase {
  final VideoRepository repository;
  RecordVideoUseCase(this.repository);

  Future<File?> call(Duration duration, Function(int) onCountdown) {
    return repository.recordVideo(duration, onCountdown);
  }
}