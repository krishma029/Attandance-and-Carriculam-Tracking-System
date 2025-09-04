import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Bottom decorative wave
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDFF2B2), Color(0xFFB4E197)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome to TrackAcademy',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Choose your role to continue',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 32),

                // Role cards
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      RoleCard(
                        icon: Icons.family_restroom,
                        title: 'Parents',
                        subtitle: 'Monitor your child’s progress',
                        onTap: () => Navigator.pushNamed(context, '/parents'),
                      ),
                      RoleCard(
                        icon: Icons.school_rounded,
                        title: 'Student',
                        subtitle: 'Track your attendance & tasks',
                        onTap: () => Navigator.pushNamed(context, '/student'),
                      ),
                      RoleCard(
                        icon: Icons.person_pin_rounded,
                        title: 'Teacher',
                        subtitle: 'Manage class attendance',
                        onTap: () => Navigator.pushNamed(context, '/teacher'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color iconBgColor = Color(0xFFE6F4EA);  // Very light green
    const Color iconColor = Color(0xFF218838);    // Dark green

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: ScaleTransition(
          scale: _scale,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Light green box behind icon
                  Container(
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Icon(widget.icon, size: 28, color: iconColor),
                  ),
                  const SizedBox(width: 20),

                  // Texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(widget.subtitle,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  ),

                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black38, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
