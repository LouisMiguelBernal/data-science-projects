// landing_page.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'how_it_works.dart';
import 'about_page.dart';
import 'camera_screen.dart';
import 'package:lottie/lottie.dart';

// Set your primary color appropriately
const kPrimaryColor = Color(0xFF4CAF50);

class LandingPage extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;
  const LandingPage({
    Key? key,
    required this.onToggleTheme,
    required this.isDark,
  }) : super(key: key);

  Future<void> _handleDetectionTap(BuildContext context) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CameraScreen())
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Permission Needed"),
          content: const Text("Camera access is required to use the Detection feature."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.grey[100],
        foregroundColor: isDark ? Colors.white : kPrimaryColor,
        titleSpacing: 15,
        title: Row(
          children: [
            Image.asset('assets/Logo/logo_new.png', height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'VisorAI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: isDark ? Colors.white : kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Replace static Icon with Lottie animation
          Lottie.asset(
            'assets/animations/Road.json',
            width: 280,
            height: 280,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            'Road Marking Detection',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Powered by TensorFlow Lite and Flutter',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          const Spacer(),
          SafeArea(
            top: false,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 42),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[900]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.info_outline_rounded,
                              size: 35,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : kPrimaryColor,
                            ),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HowItWorksPage(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Info',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 1),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.help_outline_rounded,
                              size: 35,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : kPrimaryColor,
                            ),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AboutPage(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'About',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 28,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 95,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[900]!
                                : Colors.grey[100]!,
                            width: 6,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                            const BoxShadow(
                              color: Colors.white10,
                              blurRadius: 4,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () => _handleDetectionTap(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Detect',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
