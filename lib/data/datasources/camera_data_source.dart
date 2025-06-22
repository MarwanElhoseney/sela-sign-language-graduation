import 'package:camera/camera.dart';

class CameraDataSource {
  Future<List<CameraDescription>> getAvailableCameras() async {
    return await availableCameras();
  }
}