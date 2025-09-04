// lib/parents/teacher_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Track_ademy/parents/teacher_communication_screen.dart'; // Ensure lowercase 'parents' and where Teacher is defined

// Define consistent color palette
const Color _primaryGradientStart = Color(0xFFDFF2B2);
const Color _primaryGradientEnd = Color(0xFFB4E197);
const Color _primaryAccentColor = Color(0xFF218838); // Dark green accent
const Color _iconBgColor = Color(0xFFE6F4EA); // Very light green for icon backgrounds

// Model for a chat message (ensure this Message class is only here or in a shared model file)
class Message {
  final String text;
  final DateTime timestamp;
  final bool isMe; // true if sent by parent, false if received from teacher

  Message({
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

class TeacherChatScreen extends StatefulWidget {
  final Teacher teacher; // Pass the teacher object to this screen

  const TeacherChatScreen({super.key, required this.teacher});

  @override
  State<TeacherChatScreen> createState() => _TeacherChatScreenState();
}

class _TeacherChatScreenState extends State<TeacherChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages = [
      Message(
        text: 'Hello ${widget.teacher.name}, I wanted to discuss John\'s recent Math progress.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3, minutes: 15)),
        isMe: true,
      ),
      Message(
        text: 'Hi! John is doing well. I\'ve seen significant improvement in his problem-solving skills this week.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 45)),
        isMe: false,
      ),
      Message(
        text: 'That\'s great to hear! I was a bit concerned about the last test score. Any tips for home practice?',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 20)),
        isMe: true,
      ),
      Message(
        text: 'The last test was challenging. I recommend focusing on geometry concepts. I can send some extra worksheets via email.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 10)),
        isMe: false,
      ),
      Message(
        text: 'Thank you so much! That would be very helpful. When are you available for a quick call next week?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: true,
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(Message(
          text: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isMe: true,
        ));
        _messageController.clear();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryGradientStart, _primaryGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: Icon(Icons.person, color: _primaryAccentColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.teacher.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.teacher.subject,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final alignment = message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = message.isMe ? _primaryAccentColor.withOpacity(0.8) : Colors.grey[200];
    final textColor = message.isMe ? Colors.white : Colors.black87;
    final borderRadius = BorderRadius.circular(16.0);

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: message.isMe
                  ? borderRadius.copyWith(bottomRight: const Radius.circular(4))
                  : borderRadius.copyWith(bottomLeft: const Radius.circular(4)),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: message.isMe ? 0 : 8,
              right: message.isMe ? 8 : 0,
              bottom: 8.0,
            ),
            child: Text(
              DateFormat('hh:mm a').format(message.timestamp),
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: _primaryAccentColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}