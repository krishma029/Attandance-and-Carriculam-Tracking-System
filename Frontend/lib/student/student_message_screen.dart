import 'package:flutter/material.dart';

// --- Data Models ---

// Model for an individual chat message
class Message {
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe; // True if the message was sent by the current user

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isMe = false,
  });
}

// Model for a conversation preview in the message list
class Conversation {
  final String userId; // The ID of the other person in the chat
  String lastMessage;
  DateTime lastMessageTime;
  List<Message> messages; // Stores all messages in this conversation

  Conversation({
    required this.userId,
    required this.lastMessage,
    required this.lastMessageTime,
    List<Message>? initialMessages,
  }) : messages = initialMessages ?? [];
}

// --- Chat Screen (for individual conversations) ---
class ChatScreen extends StatefulWidget {
  final Conversation conversation; // The conversation to display
  final Function(String, String) onSendMessage; // Callback to send a message

  const ChatScreen({
    super.key,
    required this.conversation,
    required this.onSendMessage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // To auto-scroll to latest message

  // Scroll to the bottom when new messages arrive or screen loads
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollToBottom(); // Scroll to bottom when screen first loads
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If conversation messages change, scroll to bottom
    if (widget.conversation.messages.length != oldWidget.conversation.messages.length) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final text = _messageController.text.trim();
      widget.onSendMessage(widget.conversation.userId, text); // Use the callback
      _messageController.clear();
      _scrollToBottom(); // Scroll to bottom after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color iconColor = Color(0xFF218838); // Dark green
    const Color iconBgColor = Color(0xFFE6F4EA); // Very light green

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Match theme
        elevation: 0,
        iconTheme: const IconThemeData(color: iconColor),
        title: Text(
          widget.conversation.userId, // Display the other user's ID
          style: const TextStyle(color: iconColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: iconColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing info for ${widget.conversation.userId}')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12.0),
              itemCount: widget.conversation.messages.length,
              itemBuilder: (context, index) {
                final message = widget.conversation.messages[index];
                return Align(
                  alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: message.isMe ? iconColor : iconBgColor, // Dark green for me, light green for others
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: message.isMe ? const Radius.circular(16) : Radius.zero,
                        bottomRight: message.isMe ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            color: message.isMe ? Colors.white : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: message.isMe ? Colors.white70 : Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      fillColor: iconBgColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: iconColor,
                  mini: true,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Main Message Page (Conversation List) ---
class StudentMessageScreen extends StatefulWidget {
  final VoidCallback onNavigateToHome;

  const StudentMessageScreen({super.key, required this.onNavigateToHome});

  @override
  State<StudentMessageScreen> createState() => _StudentMessageScreenState();
}

class _StudentMessageScreenState extends State<StudentMessageScreen> {
  // Sample conversations
  final List<Conversation> _conversations = [
    Conversation(
      userId: "Person 1",
      lastMessage: "What is today task ?",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
      initialMessages: [
        Message(senderId: "Person 1", text: "Hi, how are you?", timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
        Message(senderId: "Me", text: "I'm good, thanks! How about you?", timestamp: DateTime.now().subtract(const Duration(minutes: 25)), isMe: true),
        Message(senderId: "Person 1", text: "What is today task ?", timestamp: DateTime.now().subtract(const Duration(minutes: 15))),
      ],
    ),
    Conversation(
      userId: "Person 2",
      lastMessage: "You have today's notes?",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      initialMessages: [
        Message(senderId: "Person 2", text: "Hey, do you have the notes from today's lecture?", timestamp: DateTime.now().subtract(const Duration(hours: 1))),
      ],
    ),
    Conversation(
      userId: "Person 3",
      lastMessage: "You solved it ?",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
      initialMessages: [
        Message(senderId: "Person 3", text: "Did you manage to solve that problem?", timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 10))),
      ],
    ),
  ];

  void _addNewConversation(String userId) {
    // Check if a conversation with this userId already exists
    bool exists = _conversations.any((conv) => conv.userId.toLowerCase() == userId.toLowerCase());
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conversation with $userId already exists!')),
      );
      // Optionally navigate to existing chat
      final existingConv = _conversations.firstWhere((conv) => conv.userId.toLowerCase() == userId.toLowerCase());
      _openChat(existingConv);
      return;
    }

    // Create a new conversation
    final newConversation = Conversation(
      userId: userId,
      lastMessage: "New chat started.",
      lastMessageTime: DateTime.now(),
      initialMessages: [],
    );

    setState(() {
      _conversations.insert(0, newConversation); // Add new chat to the top
    });

    _openChat(newConversation); // Open the new chat
  }

  void _openChat(Conversation conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          conversation: conversation,
          onSendMessage: (targetUserId, messageText) {
            setState(() {
              // Find the correct conversation and add the message
              final conv = _conversations.firstWhere((c) => c.userId == targetUserId);
              conv.messages.add(Message(
                senderId: "Me",
                text: messageText,
                timestamp: DateTime.now(),
                isMe: true,
              ));
              conv.lastMessage = messageText; // Update last message for preview
              conv.lastMessageTime = DateTime.now(); // Update last message time

              // Move the updated conversation to the top of the list
              _conversations.remove(conv);
              _conversations.insert(0, conv);
            });
          },
        ),
      ),
    );
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
                    onPressed: () {
                      // Use the callback to navigate to the home/dashboard page
                      widget.onNavigateToHome();
                    },
                  ),
                  const Text(
                    "Message",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  // Removed the GestureDetector containing the notification icon
                  // Add an empty SizedBox to balance the title if desired, or remove for left alignment
                  const SizedBox(width: 40), // Adjust width or remove based on desired title alignment
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            shadowColor: gradientEnd.withOpacity(0.3),
            child: InkWell( // Use InkWell for tap effect
              onTap: () => _openChat(conversation),
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: iconBgColor,
                      child: Icon(Icons.person, color: iconColor, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation.userId,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            conversation.lastMessage,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${conversation.lastMessageTime.hour}:${conversation.lastMessageTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => NewChatDialog(
              onStartChat: (userId) {
                _addNewConversation(userId);
              },
            ),
          );
        },
        backgroundColor: iconColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// --- Dialog for New Chat ---
class NewChatDialog extends StatefulWidget {
  final Function(String) onStartChat;

  const NewChatDialog({super.key, required this.onStartChat});

  @override
  State<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  final TextEditingController _userIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color iconColor = Color(0xFF218838); // Dark green

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Start a New Chat',
        style: TextStyle(fontWeight: FontWeight.bold, color: iconColor),
      ),
      content: TextField(
        controller: _userIdController,
        decoration: InputDecoration(
          hintText: 'Enter User ID (e.g., Person 4)',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: iconColor.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: iconColor, width: 2),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: Colors.red[400]),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_userIdController.text.trim().isNotEmpty) {
              widget.onStartChat(_userIdController.text.trim());
              Navigator.pop(context); // Close the dialog
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: iconColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Start Chat'),
        ),
      ],
    );
  }
}