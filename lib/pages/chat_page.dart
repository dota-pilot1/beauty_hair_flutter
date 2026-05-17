import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

// State는 StatefulWidget의 상태를 관리하는 클래스입니다.
// react 와 바교하면 useState와 비슷한 역할을 합니다.
class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isMe: true, time: DateTime.now()));
    });
    _messageController.clear();
    _scrollToBottom();
  }

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

  // build 는 위젯의 UI를 구성하는 메서드입니다. Flutter는 이 메서드를 호출하여 화면에 표시할 위젯 트리를 생성합니다.
  // BuildContext context 의 context는 위젯 트리에서 현재 위젯의 위치를 나타내는 객체입니다. 
  // 이를 통해 부모 위젯이나 테마 등의 정보를 가져올 수 있습니다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Beauty Hair'),
      ),
      // SafeArea는 화면의 안전 영역을 고려하여 자식 위젯을 배치하는 위젯입니다.
      body: SafeArea(
        // Column은 수직으로 위젯을 배치하는 레이아웃 위젯입니다. 자식 위젯들을 수직으로 정렬합니다.
        child: Column(
        children: [
          // 메시지 목록
          // Expanded는 자식 위젯이 남은 공간을 차지하도록 하는 위젯입니다. 
          // Column 내에서 사용될 때, Expanded는 자식 위젯이 남은 공간을 차지하도록 합니다.
          Expanded(
            // ListView.builder는 스크롤 가능한 리스트를 효율적으로 생성하는 위젯입니다.
            child: ListView.builder(
              // ScrollController는 ListView의 스크롤 위치를 제어하는 데 사용됩니다.
              // ListView.builder는 스크롤 가능한 리스트를 효율적으로 생성하는 위젯입니다.
              controller: _scrollController,
              // EdgeInsets는 위젯의 패딩이나 마진을 설정하는 데 사용되는 클래스입니다.
              // EdgeInsets.all(16)은 모든 방향에 16픽셀의 패딩을 적용하는 것을 의미합니다.
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              // itemBuilder는 ListView.builder에서 각 아이템을 어떻게 빌드할지를 정의하는 함수입니다.
              itemBuilder: (context, index) {
                // _messages 리스트에서 현재 인덱스에 해당하는 메시지를 가져옵니다.
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          // 입력 영역
          // Container는 자식 위젯을 포함하는 상자입니다. 패딩, 마진, 배경색 등을 설정할 수 있습니다.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -1),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isMe ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}