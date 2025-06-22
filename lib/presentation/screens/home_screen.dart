import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sela_gradution_app/model/my_user.dart';
import 'package:sela_gradution_app/presentation/providers/home_provider.dart';

import '../../home_screen/profile_screen.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "HomeScreen";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final MyUser? user = ModalRoute.of(context)?.settings.arguments as MyUser?;
    final textController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: IndexedStack(
          index: provider.selectedTabIndex,
          children: [
            _buildMainContent(context, provider, user, textController),
            ProfileScreen(user: user),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, provider),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF3A56D0), Color(0xFF1A237E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                provider.selectedMode = "left";
                provider.selectedTabIndex = 0;
                provider.notifyListeners();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              icon: const Icon(Icons.camera_alt, size: 18),
              label: const Text("Camera Translation", style: TextStyle(fontSize: 12)),
            ),
            IconButton(
              icon: Icon(Icons.home, color: provider.selectedTabIndex == 0 ? Colors.white : Colors.white70),
              onPressed: () {
                provider.selectedTabIndex = 0;
                provider.notifyListeners();
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: provider.selectedTabIndex == 1 ? Colors.white : Colors.white70),
              onPressed: () {
                provider.selectedTabIndex = 1;
                provider.notifyListeners();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, HomeProvider provider, MyUser? user, TextEditingController textController) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/rb_44776.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Welcome, ${user?.Name ?? "Guest"}',
                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text(
                              "Welcome to our sign language world!\nLet's make communication easier for everyone.",
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -25,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: provider.selectedMode == "left"
                                        ? Colors.blue[100]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: provider.selectedMode == "left"
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      provider.selectedMode = "left";
                                      provider.notifyListeners();
                                    },
                                    child: Text(
                                      "Sign language\nto text and speech",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: provider.selectedMode == "left"
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: provider.selectedMode == "right"
                                        ? Colors.blue[100]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: provider.selectedMode == "right"
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      provider.selectedMode = "right";
                                      provider.notifyListeners();
                                    },
                                    child: Text(
                                      "Text and speech\nto sign language",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: provider.selectedMode == "right"
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: provider.selectedMode == "left"
                        ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (provider.cameras != null &&
                                  provider.cameras!.length > 1)
                                IconButton(
                                  icon: Icon(
                                    provider.currentCameraLensDirection == CameraLensDirection.front
                                        ? Icons.camera_front
                                        : Icons.camera_rear,
                                  ),
                                  onPressed: provider.switchCamera,
                                  color: Colors.blue[900],
                                ),
                              ElevatedButton.icon(
                                onPressed: (provider.isLoading ||
                                    provider.countdown > 0 ||
                                    (provider.controller.value.isInitialized &&
                                        provider.controller.value.isRecordingVideo))
                                    ? null
                                    : provider.startRecordingProcess,
                                icon: const Icon(Icons.videocam),
                                label: Text(_getButtonText(provider)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[900],
                                  foregroundColor: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: provider.controller.value.isInitialized
                                  ? Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.center,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: provider.controller.value.previewSize!.height,
                                      height: provider.controller.value.previewSize!.width,
                                      child: CameraPreview(provider.controller),
                                    ),
                                  ),
                                  if (provider.countdown > 0)
                                    Text(
                                      '${provider.countdown}',
                                      style: const TextStyle(
                                        fontSize: 120,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black)
                                        ],
                                      ),
                                    ),
                                  if (provider.controller.value.isInitialized &&
                                      provider.controller.value.isRecordingVideo)
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${provider.recordingCountdown}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (provider.isLoading)
                                    Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: const Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white)),
                                    ),
                                ],
                              )
                                  : Container(
                                color: Colors.black,
                                child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (provider.fullSentence.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    provider.fullSentence,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: provider.speakSentence,
                                      icon: const Icon(Icons.volume_up),
                                      label: const Text("Speak Sentence"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue[800],
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: provider.resetSentence,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text("Reset"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[700],
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: provider.isRightModeLoading
                                ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.blue[900]))
                                : provider.rightModeError.isNotEmpty
                                ? Center(
                                child: Text(provider.rightModeError,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16),
                                    textAlign: TextAlign.center))
                                : provider.currentImageUrl != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                provider.currentImageUrl!,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.blue[900]));
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                      child: Text(
                                          'Failed to load sign image.',
                                          style: TextStyle(
                                              color: Colors.red)));
                                },
                              ),
                            )
                                : provider.videoController != null &&
                                provider.videoController!.value.isInitialized
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: AspectRatio(
                                aspectRatio: provider.videoController!.value.aspectRatio,
                                child: VideoPlayer(provider.videoController!),
                              ),
                            )
                                : const Center(
                                child: Text(
                                  "output will appear here",
                                  style: TextStyle(color: Colors.grey),
                                )),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: provider.selectedMode == "right"
                        ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: "Type your sentence...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  // تسجيل صوتي (غير مفعّل في الكود الأصلي)
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[900],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.mic, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            if (textController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Please enter text'),
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                                ),
                              );
                            } else {
                              provider.fetchAndPlayVideo(textController.text.trim());
                              FocusScope.of(context).unfocus();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getButtonText(HomeProvider provider) {
    if (provider.controller.value.isInitialized && provider.controller.value.isRecordingVideo) {
      return 'Recording... ${provider.recordingCountdown}s';
    }
    if (provider.isLoading) {
      return "Processing...";
    }
    if (provider.countdown > 0) {
      return 'Get Ready... ${provider.countdown}s';
    }
    return "Start Recording";
  }
}