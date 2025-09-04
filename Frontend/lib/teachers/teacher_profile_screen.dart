import 'package:flutter/material.dart';

class TeacherProfileScreen extends StatefulWidget {
  final VoidCallback onNavigateToHome;

  const TeacherProfileScreen({super.key, required this.onNavigateToHome});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = "Prof. Himanshu Mehta";
    _emailController.text = "himanshu.mehta@example.com";
    _phoneController.text = "+91 98765 43210";
    _departmentController.text = "Computer Engineering";
    _experienceController.text = "8 Years";

    _setEditing(false);
  }

  void _setEditing(bool editing) {
    setState(() {
      _isEditing = editing;
    });
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Saved!')),
    );
    _setEditing(false);
  }

  void _cancelEdit() {
    _setEditing(false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFFDFF2B2);
    const Color gradientEnd = Color(0xFFB4E197);
    const Color iconColor = Color(0xFF218838);
    const Color iconBgColor = Color(0xFFE6F4EA);

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
                    onPressed: widget.onNavigateToHome,
                  ),
                  const Text(
                    "Teacher Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 40),
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
            GestureDetector(
              onTap: () {
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
                  if (_isEditing)
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

            _buildProfileField("Name", _nameController, Icons.person_outline),
            _buildProfileField("Email", _emailController, Icons.email_outlined),
            _buildProfileField("Phone", _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
            _buildProfileField("Department", _departmentController, Icons.school_outlined),
            _buildProfileField("Experience", _experienceController, Icons.timeline_outlined),

            const SizedBox(height: 40),

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
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
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
                    ),
                    child: const Text('Save', style: TextStyle(fontSize: 16)),
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
              ),
              child: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(
      String label,
      TextEditingController controller,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    const Color iconColor = Color(0xFF218838);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: !_isEditing,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: iconColor.withOpacity(0.7)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            filled: true,
            fillColor: _isEditing ? const Color(0xFFF0F7F0) : Colors.grey[100],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _isEditing ? iconColor : Colors.grey[200]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: iconColor, width: 2.0),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: _isEditing ? FontWeight.normal : FontWeight.w500,
          ),
        ),
      ]),
    );
  }
}
