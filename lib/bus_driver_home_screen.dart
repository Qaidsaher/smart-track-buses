import 'package:flutter/material.dart';
import 'login_screen.dart'; // تأكد أنه المسار صحيح حسب مشروعك

class BusDriverHomeScreen extends StatefulWidget {
  const BusDriverHomeScreen({super.key});

  @override
  _BusDriverHomeScreenState createState() => _BusDriverHomeScreenState();
}

class _BusDriverHomeScreenState extends State<BusDriverHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDriverInfo(),
                const SizedBox(height: 12),
                _buildLabel('Control panel'),
                const SizedBox(height: 12),
                _buildControlPanel(currentWidth),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBED),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF3B7962),
        ),
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Card(
        elevation: 0.2,
        shadowColor: Colors.black,
        color: const Color(0xFFFFF8F0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF3B7962),
                child: Image.asset(
                  "assets/images/image.png",
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double fontSize = constraints.maxWidth * 0.05;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _responsiveText('Driver name: ..........', fontSize),
                        _responsiveText('Driver age: ..........', fontSize),
                        _responsiveText('ID: ....................', fontSize),
                        _responsiveText(
                          'Phone: ....................',
                          fontSize,
                        ),
                        _responsiveText(
                          'Number of Years in Driving: ....................',
                          fontSize,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Icon(Icons.edit, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel(double fullWidth) {
    final width = (fullWidth / 4) - (fullWidth / 30);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          'assets/images/call.png',
          'Call the parents',
          width,
          onTap: () {
            print('Calling parents...');
          },
        ),
        _buildControlButton(
          'assets/images/report.png',
          'Reports',
          width,
          onTap: () {
            print('Opening reports...');
          },
        ),
        _buildControlButton(
          'assets/images/sos.png',
          'Emergency button',
          width,
          onTap: () {
            print('Emergency!');
          },
        ),
        _buildControlButton(
          'assets/images/camera.png',
          'Recordings',
          width,
          onTap: () {
            print('Opening recordings...');
          },
        ),
      ],
    );
  }

  Widget _buildControlButton(
    String imagePath,
    String label,
    double cardWidth, {
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: cardWidth,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, fit: BoxFit.fill),
                const SizedBox(height: 4),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double fontSize = constraints.maxWidth * 0.13;
                    return _responsiveText(
                      label,
                      fontSize,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _responsiveText(
    String text,
    double fontSize, {
    TextAlign textAlign = TextAlign.left,
    int maxLines = 1,
  }) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: const Color(0xFF3B7962),
        fontSize: fontSize.clamp(8, 14),
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
