import 'package:video_player/video_player.dart';
import '../repositories/video_repository.dart';

class FetchAndPlayVideoUseCase {
  final VideoRepository repository;
  FetchAndPlayVideoUseCase(this.repository);

  Future<VideoPlayerController?> call(
      String word,
      Function(String?) onImage,
      Function(String) onError,
      ) {
    return repository.fetchAndPlayVideo(word, onImage, onError);
  }
}