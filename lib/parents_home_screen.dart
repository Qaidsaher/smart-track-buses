import 'package:flutter/material.dart';
import 'login_screen.dart';

class ParentsHomeScreen extends StatefulWidget {
  const ParentsHomeScreen({super.key});

  @override
  _ParentsHomeScreenState createState() => _ParentsHomeScreenState();
}

class _ParentsHomeScreenState extends State<ParentsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDC),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40), // تنزل كل شي تحت شوي
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF3B7962),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStudentInfo(),
                  const SizedBox(height: 12),
                  _buildLabel('Instant Messaging'),
                  const SizedBox(height: 8),
                  _buildLabel('Control panel'),
                  _buildControlPanel(currentWidth),
                ],
              ),
            ],
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

  Widget _buildStudentInfo() {
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
                        _responsiveText('Student name: ..........', fontSize),
                        _responsiveText('Student age: ..........', fontSize),
                        _responsiveText('ID: ....................', fontSize),
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
    final width = (fullWidth / 3) - (fullWidth / 20);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              'assets/images/call.png',
              'Call the driver',
              width,
            ),
            _buildControlButton('assets/images/report.png', 'Reports', width),
            _buildControlButton(
              'assets/images/location.png',
              'Interactive map',
              width,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              'assets/images/arrivalTime.png',
              'Arrival time',
              width,
            ),
            _buildControlButton(
              'assets/images/bus.png',
              'Departure time',
              width,
            ),
            _buildControlButton(
              'assets/images/camera.png',
              'Recordings',
              width,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton(String imagePath, String label, double cardWidth) {
    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 0.2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
