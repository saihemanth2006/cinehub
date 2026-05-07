import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;
  const ChatScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Chat $conversationId'), leading: const BackButton()),
      body: Center(child: Text('Chat interface', style: AppTypography.bodyLarge)),
    );
  }
}
