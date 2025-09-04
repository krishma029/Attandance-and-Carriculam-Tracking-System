import 'package:flutter/material.dart';

class TeacherMessageScreen extends StatelessWidget {
  const TeacherMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentMessages = [
      {
        'name': 'Simran Kapoor',
        'lastMessage': 'Sir, I have a doubt in Quiz 1.',
        'time': '10:32 AM'
      },
      {
        'name': 'Aryan Joshi',
        'lastMessage': 'Can you explain binary search again?',
        'time': '9:15 AM'
      },
      {
        'name': 'Neha Sharma',
        'lastMessage': 'I am confused with loop conditions.',
        'time': 'Yesterday'
      },
      {
        'name': 'Rohit Verma',
        'lastMessage': 'Sir, when is the submission of Assignment 2?',
        'time': 'Yesterday'
      },
    ];

    final parentMessages = [
      {
        'name': 'Mrs. Mehta',
        'lastMessage': 'Can we schedule a meeting regarding Aryan?',
        'time': '8:45 AM'
      },
      {
        'name': 'Mr. Patel',
        'lastMessage': 'Please share progress of Simran.',
        'time': 'Yesterday'
      },
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE8F5E9),
          foregroundColor: const Color(0xFF2E7D32),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Messages',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Color(0xFF2E7D32)),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Color(0xFF2E7D32),
            indicatorColor: Color(0xFF2E7D32),
            tabs: [
              Tab(text: 'Students'),
              Tab(text: 'Parents'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMessageList(context, studentMessages, isParent: false),
            _buildMessageList(context, parentMessages, isParent: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, List<Map<String, String>> messages,
      {required bool isParent}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(msg['name']!),
          subtitle: Text(msg['lastMessage']!),
          trailing: Text(msg['time']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  studentName: msg['name']!,
                  isParent: isParent,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// -------------------- ChatScreen --------------------

class ChatScreen extends StatefulWidget {
  final String studentName;
  final bool isParent;

  const ChatScreen({
    super.key,
    required this.studentName,
    this.isParent = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();

    if (widget.isParent) {
      _messages.addAll([
        {
          'text': 'Hello, I’d like to discuss something regarding my child.',
          'isTeacher': false
        },
        {'text': 'Hi, how can I help you?', 'isTeacher': true},
      ]);
    } else {
      if (widget.studentName == 'Simran Kapoor') {
        _messages.addAll([
          {'text': 'Sir, I have a doubt in Quiz 1.', 'isTeacher': false},
          {'text': 'Hi Simran, what part are you stuck on?', 'isTeacher': true},
        ]);
      } else if (widget.studentName == 'Aryan Joshi') {
        _messages.addAll([
          {'text': 'Can you explain binary search again?', 'isTeacher': false},
          {'text': 'Sure Aryan, I will send you notes.', 'isTeacher': true},
        ]);
      } else if (widget.studentName == 'Neha Sharma') {
        _messages.addAll([
          {'text': 'I am confused with loop conditions.', 'isTeacher': false},
          {'text': 'Let me explain it again in tomorrow’s class.', 'isTeacher': true},
        ]);
      } else if (widget.studentName == 'Rohit Verma') {
        _messages.addAll([
          {'text': 'Sir, when is the submission of Assignment 2?', 'isTeacher': false},
          {'text': 'Tomorrow evening, don’t forget!', 'isTeacher': true},
        ]);
      } else {
        _messages.addAll([
          {'text': 'Hello sir!', 'isTeacher': false},
          {'text': 'Hi, how can I help you?', 'isTeacher': true},
        ]);
      }
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isTeacher': true});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentName),
        centerTitle: true,
        backgroundColor: const Color(0xFFE8F5E9),
        foregroundColor: const Color(0xFF2E7D32),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final alignment = msg['isTeacher']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start;
                final bubbleColor = msg['isTeacher']
                    ? Colors.green.shade100
                    : Colors.grey.shade200;

                return Column(
                  crossAxisAlignment: alignment,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['text'],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
