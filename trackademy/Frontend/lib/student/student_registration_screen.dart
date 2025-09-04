import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() => _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _enrollController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _classController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;

  static const Color iconBgColor = Color(0xFFE6F4EA);
  static const Color iconColor = Color(0xFF218838);

  /// Strict Gmail-only validator (6-30 chars, letters + digits)
  final RegExp _gmailStrict = RegExp(
    r'^(?!.*\.\.)(?!\.)[A-Za-z](?=.*\d)[A-Za-z0-9._]{5,29}(?<!\.)@gmail\.com$',
    caseSensitive: false,
  );

  /// Strong password: 8+ chars, 1 upper, 1 lower, 1 digit, 1 special
  final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  // Your backend URL
  static const String apiUrl = 'http://10.222.144.176/trackademy/student_signup.php';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _enrollController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _classController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFFDFF2B2);
    const Color gradientEnd = Color(0xFFB4E197);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [gradientStart, gradientEnd],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(60)),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // Logo
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: iconColor.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                              BoxShadow(color: Colors.white.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, -5)),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.person_add_rounded, size: 50, color: iconColor),
                          ),
                        ),

                        const SizedBox(height: 24),
                        Text("Create Account",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: iconColor,
                            )),
                        const SizedBox(height: 8),
                        Text("Join TrackAcademy as a student",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black54)),
                        const SizedBox(height: 32),

                        // Card
                        Card(
                          elevation: 8,
                          shadowColor: iconColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [Colors.white, iconBgColor.withOpacity(0.3)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Name + Enrollment
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          controller: _nameController,
                                          label: "Full Name",
                                          icon: Icons.person_outline,
                                          validator: _validateRequired,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildTextField(
                                          controller: _enrollController,
                                          label: "Enrollment No.",
                                          icon: Icons.badge_outlined,
                                          validator: _validateRequired,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Email
                                  _buildTextField(
                                    controller: _emailController,
                                    label: "Email Address",
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _validateEmail,
                                  ),
                                  const SizedBox(height: 20),

                                  // Phone + Class
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          controller: _phoneController,
                                          label: "Phone Number",
                                          icon: Icons.phone_outlined,
                                          keyboardType: TextInputType.phone,
                                          validator: _validatePhone,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildTextField(
                                          controller: _classController,
                                          label: "Class",
                                          icon: Icons.school_outlined,
                                          validator: _validateRequired,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Password
                                  _buildTextField(
                                    controller: _passwordController,
                                    label: "Password",
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    isPasswordVisible: _isPasswordVisible,
                                    onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                    validator: _validatePassword,
                                  ),
                                  const SizedBox(height: 20),

                                  // Confirm Password
                                  _buildTextField(
                                    controller: _confirmPasswordController,
                                    label: "Confirm Password",
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    isPasswordVisible: _isConfirmPasswordVisible,
                                    onTogglePassword: () =>
                                        setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                                    validator: _validateConfirmPassword,
                                  ),
                                  const SizedBox(height: 24),

                                  // Terms
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _agreeToTerms,
                                        onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                                        activeColor: iconColor,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(color: Colors.black87, fontSize: 14),
                                            children: [
                                              const TextSpan(text: "I agree to the "),
                                              TextSpan(
                                                  text: "Terms & Conditions",
                                                  style: TextStyle(
                                                      color: iconColor,
                                                      fontWeight: FontWeight.bold,
                                                      decoration: TextDecoration.underline)),
                                              const TextSpan(text: " and "),
                                              TextSpan(
                                                  text: "Privacy Policy",
                                                  style: TextStyle(
                                                      color: iconColor,
                                                      fontWeight: FontWeight.bold,
                                                      decoration: TextDecoration.underline)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 28),

                                  // Register
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: _isLoading || !_agreeToTerms ? null : _handleRegistration,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _agreeToTerms ? iconColor : Colors.grey,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        elevation: _agreeToTerms ? 8 : 2,
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                                          : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.person_add_alt, size: 20),
                                          SizedBox(width: 8),
                                          Text("Create Account",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Sign In Redirect
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(color: iconBgColor.withOpacity(0.5), borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? ", style: TextStyle(fontSize: 16)),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text("Sign In",
                                    style: TextStyle(
                                        color: iconColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Text field builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: iconColor)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword && !isPasswordVisible,
            validator: validator,
            decoration: InputDecoration(
              hintText: 'Enter your $label',
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(6)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: iconColor),
                onPressed: onTogglePassword,
              )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: iconColor, width: 2)),
            ),
          ),
        ),
      ],
    );
  }

  // Validators
  String? _validateRequired(String? value) => value == null || value.trim().isEmpty ? 'This field is required' : null;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Enter email';
    if (!_gmailStrict.hasMatch(value)) {
      return "Enter a valid Gmail (6–30 chars, letters & digits)";
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Enter phone number';
    if (!RegExp(r'^\d{10}$').hasMatch(value)) return 'Enter a valid 10-digit number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter password';
    if (!_passwordRegex.hasMatch(value)) {
      return "Password must be 8+ chars, include upper, lower, number & special (@\$!%*?&)";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  // Registration handler
  void _handleRegistration() async {
    if (!_formKey.currentState!.validate() || !_agreeToTerms) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "full_name": _nameController.text.trim(),
          "enrollment_no": _enrollController.text.trim(),
          "email": _emailController.text.trim(),
          "phone_number": _phoneController.text.trim(),
          "class": _classController.text.trim(),
          "password": _passwordController.text.trim(),
          "terms_accepted": _agreeToTerms
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result["status"] == "success") {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Registered successfully")),
            );
            Navigator.pushReplacementNamed(context, '/studentHome');
          }
        } else {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ ${result['message'] ?? 'Something went wrong'}")),
            );
          }
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Server Error: ${response.statusCode}")),
          );
        }
      }
    } on SocketException {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ No internet connection")),
      );
    } on TimeoutException {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Request timed out. Make sure the server is running.")),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Error: $e")),
        );
      }
    }
  }
}
