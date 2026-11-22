import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// Detection result class
class Detection {
  final List<double> bbox; // [xMin, yMin, xMax, yMax]
  final String className;
  final double confidence;

  Detection({
    required this.bbox,
    required this.className,
    required this.confidence,
  });
}

/// YOLOv11 Detector
class YOLOv11Detector {
  Interpreter? _interpreter;
  final int imgSize = 640;

  /// 19 road marking classes
  final List<String> classes = [
    "Bicycle_Lane",
    "Broken_and_Solid_Yellow_Lines",
    "Bus_Lane",
    "Cats_Eye",
    "Continuity_Lane",
    "Double_Solid_Yellow_or_White_Line",
    "Holding_Lane",
    "Loading_and_Unloading_Zone",
    "Motorcycle_Lane",
    "No_Loading_and_Unloading_Curb",
    "No_Parking_Curb",
    "Parking_Bay",
    "Pavement_Arrow",
    "Pedestrian_Lane",
    "Railroad_Crossing",
    "Rumble_Strips",
    "Single_Solid_Line",
    "Speed_Limit",
    "Transition_Line"
  ];

  /// Load TFLite float32 model
  Future<void> loadModel() async {
    try {
      final options = InterpreterOptions()..threads = 4;
      _interpreter = await Interpreter.fromAsset(
        'assets/model/best (1)_float32.tflite',
        options: options,
      );
      print('✅ TFLite float32 model loaded successfully');
    } catch (e) {
      print('❌ Error loading model: $e');
      rethrow;
    }
  }

  /// Detect road markings from an image
  Future<List<Detection>> detectObjects(img.Image image) async {
    // Resize to model input
    final resized = img.copyResize(image, width: imgSize, height: imgSize);

    // Convert to [1, imgSize, imgSize, 3] float32
    final input = List.generate(
      1,
      (_) => List.generate(
        imgSize,
        (y) => List.generate(
          imgSize,
          (x) {
            final pixel = resized.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    // Model output: [1, 23, 8400]
    final output = List.generate(
      1,
      (_) => List.generate(
        23,
        (_) => List.filled(8400, 0.0),
      ),
    );

    // Run inference
    _interpreter!.run(input, output);

    // Post-process predictions
    return _postProcess(output[0], image.width, image.height);
  }

  /// Convert model output to Detection objects
  List<Detection> _postProcess(List<List<double>> predictions, int originalWidth, int originalHeight) {
    List<Detection> detections = [];
    const double confThreshold = 0.3;

    // Transpose [23, 8400] -> [8400, 23]
    final transposed = List.generate(
      8400,
      (i) => List.generate(23, (j) => predictions[j][i]),
    );

    for (var box in transposed) {
      final x = box[0]; // x_center (normalized 0-1)
      final y = box[1]; // y_center
      final w = box[2]; // width
      final h = box[3]; // height

      // Class confidence
      double maxConf = 0.0;
      int maxClass = 0;
      for (int c = 0; c < 19; c++) {
        final conf = box[4 + c];
        if (conf > maxConf) {
          maxConf = conf;
          maxClass = c;
        }
      }

      if (maxConf > confThreshold) {
        final xMin = (x - w / 2) * originalWidth;
        final yMin = (y - h / 2) * originalHeight;
        final xMax = (x + w / 2) * originalWidth;
        final yMax = (y + h / 2) * originalHeight;

        detections.add(
          Detection(
            bbox: [xMin, yMin, xMax, yMax],
            className: classes[maxClass],
            confidence: maxConf,
          ),
        );
      }
    }

    return _applyNMS(detections);
  }

  /// Non-Maximum Suppression
  List<Detection> _applyNMS(List<Detection> detections, {double iouThreshold = 0.5}) {
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));
    List<Detection> result = [];

    while (detections.isNotEmpty) {
      final best = detections.removeAt(0);
      result.add(best);

      detections.removeWhere(
        (det) => _calculateIOU(best.bbox, det.bbox) > iouThreshold,
      );
    }

    return result;
  }

  /// IoU calculation
  double _calculateIOU(List<double> box1, List<double> box2) {
    final x1 = box1[0] > box2[0] ? box1[0] : box2[0];
    final y1 = box1[1] > box2[1] ? box1[1] : box2[1];
    final x2 = box1[2] < box2[2] ? box1[2] : box2[2];
    final y2 = box1[3] < box2[3] ? box1[3] : box2[3];

    final intersection =
        (x2 - x1).clamp(0, double.infinity) * (y2 - y1).clamp(0, double.infinity);

    final area1 = (box1[2] - box1[0]) * (box1[3] - box1[1]);
    final area2 = (box2[2] - box2[0]) * (box2[3] - box2[1]);
    final union = area1 + area2 - intersection;

    return union == 0 ? 0 : intersection / union;
  }

  void dispose() {
    _interpreter?.close();
  }
}