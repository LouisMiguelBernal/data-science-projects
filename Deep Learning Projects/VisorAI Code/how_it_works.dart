import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF4CAF50);

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const overview =
        'VisorAI is a compact on-device road marking detection app using YOLOv11, '
        'optimized for Samsung Galaxy devices with Snapdragon chipsets. It helps improve driving awareness by identifying road markings in real-time.';
    const captureFlow =
        '1. Opens camera and streams frames.\n'
        '2. Frames are resized to 320×320 pixels and normalized to fit model input and optimize real time performance.\n'
        '3. Detection inference runs throttled at approximately every 300 milliseconds for smooth performance.';
    const inferenceDetails =
        'The YOLOv11 model outputs bounding box coordinates (center x, center y, width, height) '
        'along with 19 class scores. Non-Maximum Suppression (NMS) is applied to eliminate duplicate detections, '
        'ensuring precise and reliable results.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('How it Works'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        titleSpacing: -5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Overview',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(overview),
          SizedBox(height: 16),
          Text(
            'Capture Flow',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(captureFlow),
          SizedBox(height: 16),
          Text(
            'Inference Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(inferenceDetails),
        ],
      ),
    );
  }
}
