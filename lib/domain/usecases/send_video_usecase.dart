import 'dart:io';
import '../repositories/video_repository.dart';

class SendVideoUseCase {
  final VideoRepository repository;
  SendVideoUseCase(this.repository);

  Future<String?> call(File videoFile) {
    return repository.sendVideo(videoFile);
  }
}