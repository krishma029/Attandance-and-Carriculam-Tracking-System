// lib/student_profile_screen.dart
import 'package:flutter/material.dart';

class StudentProfileScreen extends StatefulWidget {
  final VoidCallback onNavigateToHome; // Callback to navigate to the home/dashboard

  const StudentProfileScreen({super.key, required this.onNavigateToHome});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _enrollmentNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController(); // Added more field
  final TextEditingController _dateOfBirthController = TextEditingController(); // Added more field
  final TextEditingController _addressController = TextEditingController();     // Added more field

  // State to manage edit mode
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize with dummy data (in a real app, this would come from a backend)
    _nameController.text = "John Doe";
    _enrollmentNoController.text = "20230012345";
    _emailController.text = "john.doe@example.com";
    _passwordController.text = "********"; // Never show real password
    _phoneNumberController.text = "+91 98765 43210";
    _dateOfBirthController.text = "2005-01-15";
    _addressController.text = "123, University Road, Rajkot, Gujarat";

    // Start in view mode
    _setEditing(false);
  }

  void _setEditing(bool editing) {
    setState(() {
      _isEditing = editing;
      // Set readOnly for text fields based on editing mode
      // These lines were causing issues with constant values, removed for simplicity
      // and text fields will behave based on the 'readOnly' property passed to _buildProfileField
    });
  }

  void _saveProfile() {
    // In a real application, you would send this data to your backend
    print("Saving Profile:");
    print("Name: ${_nameController.text}");
    print("Enrollment No: ${_enrollmentNoController.text}");
    print("Email: ${_emailController.text}");
    print("Phone: ${_phoneNumberController.text}");
    print("DOB: ${_dateOfBirthController.text}");
    print("Address: ${_addressController.text}");
    // Password would typically be handled via a separate "Change Password" flow
    // print("Password: ${_passwordController.text}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Saved!')),
    );
    _setEditing(false); // Exit edit mode after saving
  }

  void _cancelEdit() {
    // Revert changes (in a real app, reload original data from model/backend)
    // For this example, we'll just switch back to view mode without saving
    _setEditing(false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _enrollmentNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirthController.text.isNotEmpty
          ? DateTime.parse(_dateOfBirthController.text)
          : DateTime(2000), // Default to a reasonable year
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF218838), // Dark green for header/selected date
              onPrimary: Colors.white, // Text color on primary
              onSurface: Colors.black87, // Text color for dates
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF218838), // Dark green for buttons
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked.toString().split(' ')[0] != _dateOfBirthController.text) {
      setState(() {
        _dateOfBirthController.text = picked.toString().split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFFDFF2B2); // Light green gradient start
    const Color gradientEnd = Color(0xFFB4E197);   // Light green gradient end
    const Color iconColor = Color(0xFF218838);    // Dark green
    const Color iconBgColor = Color(0xFFE6F4EA);  // Very light green

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      widget.onNavigateToHome(); // Use the callback to go to home/dashboard
                    },
                  ),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  // Removed the GestureDetector containing the notification icon
                  // GestureDetector(
                  //   onTap: () {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text('Notifications tapped!')),
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white.withOpacity(0.2),
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: const Icon(
                  //       Icons.notifications_outlined,
                  //       color: Colors.white,
                  //       size: 22,
                  //     ),
                  //   ),
                  // ),
                  // Add an empty SizedBox to balance the title if needed,
                  // or align the title to the left/center with Spacer().
                  const SizedBox(width: 40), // Placeholder to keep title centered if desired, adjust as needed.
                  // Or remove for left alignment with back button.
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture Section
            GestureDetector(
              onTap: () {
                // Handle profile picture edit/selection
                if (_isEditing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profile picture')),
                  );
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: iconBgColor,
                    child: Icon(Icons.person, size: 70, color: iconColor),
                  ),
                  if (_isEditing) // Show edit icon only when editing
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isEditing ? "Tap to change profile picture" : "View Profile",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _isEditing ? iconColor : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 30),

            // Profile Details
            _buildProfileField(
              label: "Name",
              controller: _nameController,
              isEditing: _isEditing,
              icon: Icons.person_outline,
            ),
            _buildProfileField(
              label: "Enrollment no.",
              controller: _enrollmentNoController,
              isEditing: _isEditing,
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
            ),
            _buildProfileField(
              label: "Email",
              controller: _emailController,
              isEditing: _isEditing,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildProfileField(
              label: "Password",
              controller: _passwordController,
              isEditing: _isEditing,
              isObscureText: true,
              icon: Icons.lock_outline,
              // Password should typically not be directly editable here.
              // A separate "Change Password" button/flow is better.
              // For demonstration, we'll keep it editable but masked.
            ),
            // Added More Fields:
            _buildProfileField(
              label: "Phone Number",
              controller: _phoneNumberController,
              isEditing: _isEditing,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            _buildProfileField(
              label: "Date of Birth",
              controller: _dateOfBirthController,
              isEditing: _isEditing,
              icon: Icons.calendar_today_outlined,
              readOnly: true, // Make this read-only and open date picker
              onTap: _isEditing ? () => _selectDate(context) : null,
            ),
            _buildProfileField(
              label: "Address",
              controller: _addressController,
              isEditing: _isEditing,
              icon: Icons.location_on_outlined,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 40),

            // Action Buttons
            _isEditing
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelEdit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red[400],
                      side: BorderSide(color: Colors.red[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iconColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            )
                : ElevatedButton(
              onPressed: () => _setEditing(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 50), // Extra space for bottom nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isObscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    const Color iconColor = Color(0xFF218838); // Dark green

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: !isEditing || readOnly, // Read-only if not editing OR if explicitly set to readOnly
            keyboardType: keyboardType,
            obscureText: isObscureText && !isEditing, // Obscure only when not editing
            onTap: onTap, // For date picker, etc.
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: iconColor.withOpacity(0.7)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              filled: true,
              fillColor: isEditing ? const Color(0xFFF0F7F0) : Colors.grey[100], // Lighter background when editing
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: isEditing ? iconColor : Colors.grey[200]!, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: iconColor, width: 2.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: isEditing ? FontWeight.normal : FontWeight.w500, // Make text slightly bolder when not editing
            ),
          ),
        ],
      ),
    );
  }
}