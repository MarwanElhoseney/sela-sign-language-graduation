import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class RemoteDataSource {
  Future<String?> sendVideoToServer(File videoFile) async {
    final uri = Uri.parse('http://192.168.1.2:5000/predict');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('video', videoFile.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final prediction = json.decode(respStr)['prediction'];
      return prediction?.toString();
    } else {
      return null;
    }
  }

  Future<File?> fetchVideoFromServer(String word) async {
    final url = Uri.parse('http://192.168.1.2:5001/video?word=${Uri.encodeComponent(word)}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp_video.mp4');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      return null;
    }
  }

  Future<String?> getLetterImage(int letterId) async {
    return 'http://192.168.1.2:5002/get_letter_image/$letterId/0';
  }
}