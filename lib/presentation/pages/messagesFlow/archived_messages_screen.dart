import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';

class ArchivedMessagesScreen extends StatelessWidget {
  const ArchivedMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: CustomAppBar(text: 'Messages Archived', text1: ''),
            ),
            Expanded(
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Text1(
                      text1: 'Archived Conversations',
                      size: 17,
                    ),
                  ),
                  _buildConversation(
                    'Customer 1',
                    'Thank you for the help!',
                    'images/c3.png',
                    '1 day ago',
                  ),
                  _buildConversation(
                    'Customer 2',
                    'Order received successfully.',
                    'images/c2.png',
                    '2 days ago',
                  ),
                  _buildConversation(
                    'Customer 3',
                    'Great service!',
                    'images/c3.png',
                    '3 days ago',
                  ),
                  _buildConversation(
                    'Customer 4',
                    'I need assistance with my order.',
                    'images/c4.png',
                    '4 days ago',
                  ),
                  _buildConversation(
                    'Customer 5',
                    'Quick response time, thank you!',
                    'images/c5.png',
                    '5 days ago',
                  ),
                  _buildConversation(
                    'Customer 6',
                    'Could you update my shipping address?',
                    'images/c2.png',
                    '6 days ago',
                  ),
                  _buildConversation(
                    'Customer 7',
                    'Order has been delayed.',
                    'images/c4.png',
                    '7 days ago',
                  ),
                  _buildConversation(
                    'Customer 8',
                    'Thanks for resolving the issue.',
                    'images/c3.png',
                    '8 days ago',
                  ),
                  _buildConversation(
                    'Customer 9',
                    'Will order again soon!',
                    'images/c3.png',
                    '9 days ago',
                  ),
                  _buildConversation(
                    'Customer 10',
                    'Product quality is excellent!',
                    'images/c5.png',
                    '10 days ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversation(
      String name, String message, String imagePath, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: ListTile(
          leading: Image.asset(imagePath),
          title: Text1(text1: name),
          subtitle: Text2(text2: message),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text2(text2: time),
          ),
          onTap: () {
            // Handle conversation tap
          },
        ),
      ),
    );
  }
}
