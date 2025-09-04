import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeacherRegistrationScreen extends StatefulWidget {
  const TeacherRegistrationScreen({super.key});

  @override
  State<TeacherRegistrationScreen> createState() =>
      _TeacherRegistrationScreenState();
}

class _TeacherRegistrationScreenState extends State<TeacherRegistrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  static const Color iconColor = Color(0xFF218838);
  static const Color iconBgColor = Color(0xFFE6F4EA);

  /// Strict Gmail-only validator (must start with a letter, have 1+ digit, no consecutive dots)
  final RegExp _gmailStrict = RegExp(
    r'^(?!.*\.\.)(?!\.)[A-Za-z](?=.*\d)[A-Za-z0-9._]{5,29}(?<!\.)@gmail\.com$',
    caseSensitive: false,
  );

  /// Strong password: 8+ chars, 1 upper, 1 lower, 1 digit, 1 special char
  final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  // Use your PC's local IP for real devices on same Wi-Fi
  static const String apiUrl =
      'http://10.222.144.176/trackademy/teacher_signup.php';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _teacherIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate() || !_agreeToTerms) return;

    setState(() => _isLoading = true);

    try {
      final response = await http
          .post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "full_name": _nameController.text.trim(),
          "teacher_id": _teacherIdController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result["status"] == "success") {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Registered successfully")),
            );
            Navigator.pushReplacementNamed(context, '/teacherHome');
          }
        } else {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                Text("❌ ${result['message'] ?? 'Something went wrong'}"),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "❌ Server Error: ${response.statusCode} ${response.reasonPhrase}")),
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
        const SnackBar(
            content: Text(
                "⚠️ Request timed out. Make sure the server is running.")),
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

  String? _validateRequired(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Enter email';
    if (!_gmailStrict.hasMatch(value)) return "Enter a valid Gmail (must have 1+ digit)";
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

  @override
  Widget build(BuildContext context) {
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
                  colors: [Color(0xFFDFF2B2), Color(0xFFB4E197)],
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
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildHeaderIcon(),
                        const SizedBox(height: 24),
                        _buildTitle(),
                        const SizedBox(height: 32),
                        _buildFormCard(),
                        const SizedBox(height: 24),
                        _buildSignInRedirect(),
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

  Widget _buildHeaderIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: iconColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10)),
          BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 20,
              offset: const Offset(0, -5)),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration:
        BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.manage_accounts_rounded, size: 50, color: iconColor),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text("Create Teacher Account",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold, color: iconColor)),
        const SizedBox(height: 8),
        Text("Join TrackAcademy as a teacher",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black54)),
      ],
    );
  }

  Widget _buildFormCard() {
    return Card(
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
              _buildTextField(_nameController, "Full Name",
                  Icons.person_outline, validator: _validateRequired),
              const SizedBox(height: 20),
              _buildTextField(_teacherIdController, "Teacher ID",
                  Icons.badge_outlined, validator: _validateRequired),
              const SizedBox(height: 20),
              _buildTextField(_emailController, "Email", Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail),
              const SizedBox(height: 20),
              _buildTextField(_phoneController, "Phone", Icons.phone_outlined,
                  keyboardType: TextInputType.phone, validator: _validatePhone),
              const SizedBox(height: 20),
              _buildTextField(_passwordController, "Password", Icons.lock_outline,
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onTogglePassword: () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  },
                  validator: _validatePassword),
              const SizedBox(height: 20),
              _buildTextField(
                  _confirmPasswordController, "Confirm Password", Icons.lock_outline,
                  isPassword: true,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onTogglePassword: () {
                    setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                  },
                  validator: _validateConfirmPassword),
              const SizedBox(height: 24),
              _buildTermsCheckbox(),
              const SizedBox(height: 28),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
          activeColor: iconColor,
        ),
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
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
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
                strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_alt, size: 20),
            SizedBox(width: 8),
            Text("Register",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInRedirect() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
          color: iconBgColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16)),
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
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
        bool isPassword = false,
        bool isPasswordVisible = false,
        VoidCallback? onTogglePassword,
        String? Function(String?)? validator,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, color: iconColor)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
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
                decoration:
                BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(6)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                    color: iconColor),
                onPressed: onTogglePassword,
              )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: iconColor, width: 2)),
            ),
          ),
        ),
      ],
    );
  }
}
