import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarttrack_buss/UserData.dart';
import 'package:smarttrack_buss/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Role? selectedRole = Role.parents;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Passwords do not match.");
      setState(() => _isLoading = false);
      return;
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      String roleString = selectedRole.toString().split('.').last;

      await FirebaseDatabase.instance
          .ref('users/${userCredential.user?.uid}')
          .set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'role': roleString,
          });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? "Signup failed. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Signup Failed"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDC),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.28,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.30,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image.asset('assets/images/logo.png', height: 120),
                const SizedBox(height: 10),
                const Text(
                  "SmartTrack Bus",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Create New Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C8055),
                  ),
                ),
                const Text(
                  "Sign up to continue",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 30),

                _buildTextField("Name", controller: _nameController),
                _buildTextField("Email", controller: _emailController),
                _buildTextField(
                  "Password",
                  controller: _passwordController,
                  isPassword: true,
                ),
                _buildTextField(
                  "Confirm Password",
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildIconButton(
                        context,
                        'assets/images/parents.png',
                        "Parents",
                        Role.parents,
                      ),
                    ),
                    Expanded(
                      child: _buildIconButton(
                        context,
                        'assets/images/bus.png',
                        "Bus Driver",
                        Role.busDriver,
                      ),
                    ),
                    Expanded(
                      child: _buildIconButton(
                        context,
                        'assets/images/school.png',
                        "School Management",
                        Role.schoolManagement,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                _buildSignUpButton(context),
              ],
            ),
          ),
          Positioned(
            top: 60,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: TextField(
        controller: controller,
        obscureText:
            isPassword
                ? (label == "Confirm Password"
                    ? _obscureConfirmPassword
                    : _obscurePassword)
                : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      (label == "Confirm Password"
                              ? _obscureConfirmPassword
                              : _obscurePassword)
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (label == "Confirm Password") {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        } else {
                          _obscurePassword = !_obscurePassword;
                        }
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    String imagePath,
    String label,
    Role role,
  ) {
    bool isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF4C8055) : Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              imagePath,
              height: 45,
              color: isSelected ? Colors.white : null,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF4C8055) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4C8055),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}
  // Widget _buildSignUpButton() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
  //     // Adjust bottom margin here
  //     child: ElevatedButton(
  //       onPressed: _signUp,
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Color(0xFF4C8055),
  //         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  //       ),
  //       child: Text(
  //         "Sign up",
  //         style: TextStyle(
  //             fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  //       ),
  //     ),
  //   );
  // }
