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
    final password = _passwordController.text;

    // 1. CHECK IF EMAIL EXISTS IN OUR "AUTH DATABASE"
    if (!MockData.userCredentials.containsKey(email)) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account not found.'), backgroundColor: AppTheme.danger),
      );
      return;
    }

    // 2. CHECK IF PASSWORD MATCHES
    if (MockData.userCredentials[email] != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect password.'), backgroundColor: AppTheme.danger),
      );
      return; // Stop here if password is wrong
    }

    // 3. STUDENT CHECK
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
          const SnackBar(content: Text('Student account not found in database.'), backgroundColor: AppTheme.danger),
        );
      }
      return;
    }

    // 4. ADMIN CHECK
    if (email == 'admin@isatu.edu') {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const MainScreen())
      );
      return;
    }

    // 5. INVALID FORMAT
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid ISAT-U email address.'), backgroundColor: AppTheme.warning),
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
      // We use a Container with BoxDecoration to set the full-page background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, // Fallback color
          image: DecorationImage(
            image: const AssetImage('assets/isatu_bg.jpeg'),
            fit: BoxFit.cover,
            // --- ADJUST TRANSPARENCY HERE ---
            // 0.1 is very light, 0.5 is more visible.
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.3), 
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                // Semi-transparent card to show the background slightly
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), 
                    blurRadius: 20, 
                    offset: const Offset(0, 10)
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- LOGO SECTION ---
                  Center(
                    child: Image.asset(
                      'assets/logo.jpg',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppTheme.primaryLight.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.school_rounded, size: 48, color: AppTheme.primary),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'ISAT U Portal', 
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold, 
                        color: AppTheme.textPrimary
                      )
                    ),
                  ),
                  Center(
                    child: Text(
                      'Sign in to continue', 
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, 
                        color: AppTheme.textSecondary
                      )
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Email Address', 
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, 
                      fontWeight: FontWeight.w600, 
                      color: AppTheme.textPrimary
                    )
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Username or ISAT U email',
                      filled: true,
                      fillColor: Colors.white, // Solid white for better readability
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Password', 
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, 
                      fontWeight: FontWeight.w600, 
                      color: AppTheme.textPrimary
                    )
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white, // Solid white for better readability
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Sign In', 
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15, 
                          fontWeight: FontWeight.w600, 
                          color: Colors.white
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}