import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/mock_data.dart';
import 'main_screen.dart'; // The Admin Dashboard
import 'student_dashboard.dart'; // The Student Dashboard

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

void _handleLogin() {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text; // Get the password!

    // 1. CHECK IF EMAIL EXISTS IN OUR "AUTH DATABASE"
    if (!MockData.userCredentials.containsKey(email)) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account not found.'), backgroundColor: AppTheme.danger),
      );
      return;
    }

<<<<<<< HEAD
    // 2. CHECK IF PASSWORD MATCHES
    if (MockData.userCredentials[email] != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect password.'), backgroundColor: AppTheme.danger),
      );
=======
    // 2. STUDENT CHECK
    if (email.endsWith('@students.isatu.edu')) {
      try {
        final student = MockData.students.firstWhere((s) => s.email == email);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDashboard(studentId: student.id),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student account not found in database.'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
>>>>>>> 5ac5acaf2047f30b6522c817e4f2ac195e025b10
      return;
    }

    // 3. IF PASSWORD IS CORRECT, ROUTE THEM:
    if (email == 'admin@isatu.edu') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      // It's a student! Find their profile and log them in.
      final student = MockData.students.firstWhere((s) => s.email == email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentDashboard(studentId: student.id)),
      );
    }

    // 3. INVALID FORMAT
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid ISAT-U email address.'),
        backgroundColor: AppTheme.warning,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMain,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 48,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'ISAT-U Portal',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Sign in to continue',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Email Address',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'username or email',
                  filled: true,
                  fillColor: AppTheme.bgMain,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Password',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  filled: true,
                  fillColor: AppTheme.bgMain,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
