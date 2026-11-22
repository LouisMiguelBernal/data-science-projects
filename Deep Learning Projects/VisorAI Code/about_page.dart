import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF4CAF50);

// List of labels. Consider centralizing in a config/constants file for reuse.
const List<String> kLabels = [
  "Bicycle Lane",
  "Broken and Solid Yellow Lines",
  "Bus Lane",
  "Cats Eye",
  "Continuity Lane",
  "Double Solid Yellow or White Line",
  "Holding Lane",
  "Loading and Unloading Zone",
  "Motorcycle Lane",
  "No Loading and Unloading Curb",
  "No Parking Curb",
  "Parking Bay",
  "Pavement Arrow",
  "Pedestrian Lane",
  "Railroad Crossing",
  "Rumble Strips",
  "Single Solid Line",
  "Speed Limit",
  "Transition Line",
];

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labelList = kLabels.map((l) => '• $l').join('\n');
    const license = 'Demo app — not for safety-critical use. Users should always prioritize road safety and use this tool as a supplemental aid only.';
    const appPurpose =
        'VisorAI is a compact on-device road marking detection application designed to enhance driver awareness '
        'by recognizing various road markings in real-time with high accuracy.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        titleSpacing: -5,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "VisorAI",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(appPurpose),
            const SizedBox(height: 16),
            const Text(
              'Included Classes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(labelList),
            const SizedBox(height: 24),
            const Text(
              'License & Usage',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(license),
            const SizedBox(height: 24),
            const Text(
              'Development',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Developed using Flutter and TensorFlow Lite, optimized for mobile deployment and real-time '
              'performance, offering an assistive tool for safer driving experiences.',
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Version 1.0.5',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
