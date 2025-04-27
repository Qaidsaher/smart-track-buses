import 'package:flutter/material.dart';
import 'login_screen.dart'; // ✅ للرجوع إلى صفحة تسجيل الدخول

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDC), // ✅ نفس لون الخلفية المتفق عليه
      appBar: AppBar(
        backgroundColor: const Color(
          0xFFF5EEDC,
        ), // ✅ يخلي لون الـ AppBar مطابق للخلفية
        elevation: 0, // ✅ يشيل الظل
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // ✅ سهم الرجوع
          onPressed: () {
            Navigator.pop(context); // ✅ يرجع للصفحة السابقة
          },
        ),
      ),
      body: Stack(
        children: [
          /// 🌿 **الشاشة الخضراء (ثابتة لا تتحرك)**
          Positioned(
            top:
                MediaQuery.of(context).size.height *
                0.16, // ✅ تم إنزالها قليلًا
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.35,
            ),
          ),

          /// **📌 تصميم الشاشة**
          Column(
            mainAxisAlignment: MainAxisAlignment.start, // ✅ يبدأ من الأعلى
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// **📌 الشعار واسم التطبيق (تم إنزالهما قليلاً)**
              const SizedBox(height: 60), // ✅ تم إنزال كل المحتوى للأسفل أكثر
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 4), // ✅ تقليل المسافة بين الشعار والجملة
              const Text(
                "SmartTrack Bus",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 80), // ✅ تم إنزال باقي العناصر للأسفل أكثر
              /// **📌 العنوان**
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(
                    0xFF4C8055,
                  ), // ✅ لون أخضر مطابق لصفحة تسجيل الدخول
                ),
              ),

              const SizedBox(
                height: 25,
              ), // ✅ تم إنزال الحقل وزر إعادة التعيين أكثر للأسفل
              /// **📌 حقل الإدخال**
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _buildTextField("Enter your email"),
              ),

              const SizedBox(height: 50), // ✅ تم إنزال زر إعادة التعيين للأسفل
              /// **📌 زر إعادة تعيين كلمة المرور**
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    // MaterialPageRoute(builder: (context) => LoginScreen(userType: "User")), // ✅ يرجع لصفحة تسجيل الدخول
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ), // ✅ يرجع لصفحة تسجيل الدخول
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C8055), // ✅ لون الزر أخضر
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 50,
                  ), // ✅ تكبير الزر
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // ✅ تدوير الزر
                  ),
                ),
                child: const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// **📌 دالة لإنشاء حقل إدخال**
  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
      ),
    );
  }
}
