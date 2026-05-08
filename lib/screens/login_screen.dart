import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          // We wrap the entire Form in a ConstrainedBox or SizedBox 
          // to keep it from stretching too wide on web or tablets.
          child: SizedBox(
            width: 350, // This makes the "space" for the words shorter
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.school, size: 60, color: Colors.deepPurple),
                  const SizedBox(height: 10),
                  Text(
                    "Student Portal",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 30),
                  
                  // --- EMAIL FIELD ---
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Student Number",
                      isDense: true, // This makes the box vertically shorter
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Tighter space
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12), // Shorter gap between fields
                  
                  // --- PASSWORD FIELD ---
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      isDense: true, 
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock, size: 20),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Login"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text("Create Account"),
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