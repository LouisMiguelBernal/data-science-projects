import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart'; // For compute
import 'yolo_detector.dart';

const kPrimaryColor = Color(0xFF4CAF50);

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  YOLOv11Detector? _detector;
  List<Detection> _detections = [];
  bool _isProcessing = false;
  bool _isModelLoaded = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _lastAnnouncedClass;

  // Map class names to descriptions
  final Map<String, String> classDescriptions = {
    'Bicycle Lane': 'A dedicated lane marked for bicycle use only.',
    'Broken and Solid Yellow Lines': 'Indicates passing is allowed from one side only.',
    'Bus Lane': 'A lane reserved exclusively for buses during certain hours.',
    'Cats Eye': 'Reflective road studs that guide drivers at night for visibility.',
    'Continuity Lane': 'Marks where one road continues across another.',
    'Double Solid Yellow or White Line': 'No overtaking or crossing is allowed from either directions.',
    'Single Solid Line': 'Crossing or overtaking is discouraged.',
    'Rumble Strips': 'Raised or groove patterns that alert drivers through vibration and sound.',
    'Transition Line': 'Indicates lane merging, diverging, or road narrowing.',
    'No Parking Curb': 'Curb zones where vehicle parking is not allowed.',
    'Speed Limit': 'Painted speed limit sign for road speed restriction for vehicles.',
    'Pavement Arrow': 'Directional arrows painted on the road to guide vehicle movement.',
    'Railroad Crossing': 'Marks where a railway crosses the road, caution is required.',
    'Pedestrian Lane': 'Zebra marked path for pedestrian crossing.',
    'Holding Lane': 'A temporary stopping area, often in intersections.',
    'Parking Bay': 'Marks space designated for vehicle parking.',
    'No Loading and Unloading Curb': 'Curb marking indicated stopping for loading and unloading is prohibited.',
    'Loading and Unloading Zone': 'Designated area for goods delivery or passenger drop off.',
    'Motorcycle Lane': 'A narrow lane specifically marked for motorcycle use.',
  };

  String? _currentDetectedClass;
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      _detector = YOLOv11Detector();
      await _detector!.loadModel();
      setState(() => _isModelLoaded = true);

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('No cameras found');
        return;
      }

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.low, // << LOW RESOLUTION
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(FlashMode.off);
      await _cameraController!.lockCaptureOrientation(DeviceOrientation.portraitUp);

      setState(() {});
      _startDetectionLoop();
    } catch (e) {
      print('Error initializing: $e');
    }
  }

  void _startDetectionLoop() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (!mounted || _isProcessing || _cameraController == null) return;
      _isProcessing = true;
      try {
        final image = await _cameraController!.takePicture();
        final bytes = await image.readAsBytes();

        final detections = await compute(_detectInIsolate, {'bytes': bytes, 'detector': _detector!});
        if (!mounted) return;

        setState(() {
          _detections = detections['detections'] as List<Detection>;
          _imageSize = detections['imageSize'] as Size;

          if (_detections.isNotEmpty) {
            _currentDetectedClass = _detections.first.className.replaceAll('_', ' ').trim();
          } else {
            _currentDetectedClass = null;
          }
        });

        _handleAuditoryFeedback(_detections);
      } catch (e) {
        debugPrint('Detection error: $e');
      } finally {
        _isProcessing = false;
      }
    });
  }

  // Background isolate function
  static Future<Map<String, dynamic>> _detectInIsolate(Map<String, dynamic> params) async {
    final Uint8List bytes = params['bytes'];
    final YOLOv11Detector detector = params['detector'];

    final img.Image? decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) return {'detections': <Detection>[], 'imageSize': Size.zero};

    final detections = await detector.detectObjects(decodedImage);
    return {'detections': detections, 'imageSize': Size(decodedImage.width.toDouble(), decodedImage.height.toDouble())};
  }

  void _handleAuditoryFeedback(List<Detection> detections) async {
    if (detections.isEmpty) return;
    final String detectedClass = detections.first.className;
    if (_lastAnnouncedClass != detectedClass) {
      _lastAnnouncedClass = detectedClass;
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('sounds/$detectedClass.mp3'));
      } catch (e) {
        debugPrint('Audio error: $e');
      }
    }
  }

  void _replayCurrentClass() async {
    if (_lastAnnouncedClass == null) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/${_lastAnnouncedClass!}.mp3'));
    } catch (e) {
      debugPrint('Replay audio error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(_isModelLoaded ? 'Loading camera...' : 'Loading model...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1 / _cameraController!.value.aspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CameraPreview(_cameraController!),
                      if (_imageSize != null)
                        CustomPaint(
                          painter: DetectionPainter(
                            _detections,
                            Size(MediaQuery.of(context).size.width * 0.9,
                                MediaQuery.of(context).size.width * 0.9 / _cameraController!.value.aspectRatio),
                            _imageSize!,
                          ),
                        ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Detections: ${_detections.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: const Icon(Icons.replay, color: Colors.white),
                            onPressed: _lastAnnouncedClass == null ? null : _replayCurrentClass,
                            tooltip: 'Replay auditory feedback',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _currentDetectedClass != null && classDescriptions.containsKey(_currentDetectedClass!)
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                _currentDetectedClass!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up, color: Colors.white),
                              onPressed: _lastAnnouncedClass == null ? null : _replayCurrentClass,
                              tooltip: 'Replay auditory feedback',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          classDescriptions[_currentDetectedClass!]!,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : const Text(
                      "No road marking detected",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _cameraController?.dispose();
    _detector?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class DetectionPainter extends CustomPainter {
  final List<Detection> detections;
  final Size displaySize;
  final Size actualImageSize;

  DetectionPainter(this.detections, this.displaySize, this.actualImageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final scaleX = size.width / actualImageSize.width;
    final scaleY = size.height / actualImageSize.height;

    for (var detection in detections) {
      final rect = Rect.fromLTRB(
        detection.bbox[0] * scaleX,
        detection.bbox[1] * scaleY,
        detection.bbox[2] * scaleX,
        detection.bbox[3] * scaleY,
      );

      canvas.drawRect(rect, paint);

      final label =
          '${detection.className} ${(detection.confidence * 100).toStringAsFixed(0)}%';
      textPainter.text = TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          backgroundColor: Colors.green,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(rect.left, rect.top - 20));
    }
  }

  @override
  bool shouldRepaint(covariant DetectionPainter oldDelegate) => true;
}
