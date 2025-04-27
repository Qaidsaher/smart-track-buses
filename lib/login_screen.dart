import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smarttrack_buss/parents_home_screen.dart';
import 'package:smarttrack_buss/bus_driver_home_screen.dart';
import 'package:smarttrack_buss/school_management_home_screen.dart';
import 'forgot_password_screen.dart' as forgot;
import 'signup_screen.dart' as signup;
import 'home_screen.dart'; // استيراد صفحة الهوم

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        _checkUserRole();
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? "Login failed. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkUserRole() async {
    final databaseRef = _database.ref('users/${_auth.currentUser!.uid}');

    try {
      final DatabaseEvent event = await databaseRef.once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        var userData = snapshot.value as Map<dynamic, dynamic>?;
        if (userData != null && userData['role'] != null) {
          String userRole = userData['role'];
          if (userRole == 'parents') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ParentsHomeScreen()),
            );
          } else if (userRole == 'busDriver') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BusDriverHomeScreen()),
            );
          } else if (userRole == 'schoolManagement') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SchoolManagementHomeScreen(),
              ),
            );
          } else {
            _showErrorDialog('User role unknown: $userRole');
          }
        } else {
          _showErrorDialog('User role not found');
        }
      } else {
        _showErrorDialog('User data not found');
      }
    } catch (e) {
      _showErrorDialog('Error fetching user data: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Login Failed"),
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
      resizeToAvoidBottomInset: true,
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
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 80),
                  Image.asset('assets/images/logo.png', height: 120),
                  const SizedBox(height: 5),
                  const Text(
                    "SmartTrack Bus",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C8055),
                    ),
                  ),
                  const Text(
                    "Sign in to continue",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField("Email", controller: _emailController),
                  const SizedBox(height: 15),
                  _buildTextField(
                    "Password",
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 25),
                  _buildLoginButton(context),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => signup.SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create New Account",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C8055),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => forgot.ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C8055),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
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
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
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
                  "Login",
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
