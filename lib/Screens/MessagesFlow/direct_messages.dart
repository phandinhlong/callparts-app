import 'package:flutter/material.dart';
import 'package:autopartsstoreapp/Screens/MessagesFlow/search_message_screen.dart';
import 'package:autopartsstoreapp/Widgets/customapp_bar.dart';


import '../../Constants/colors.dart';
import '../../Widgets/customtextfield.dart';
import '../../Widgets/detailstext1.dart';
import '../../Widgets/detailstext2.dart';
import 'all_conversions.dart';

class DirectMessages extends StatelessWidget {
  const DirectMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              child: CustomAppBar(text: 'Messages', text1: ''),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
              child:   InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchMessagesScreen()),
                  );
                },
                child: const CustomTextField(label: 'Search',icon: Icons.search,),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllConversions()),
                );
              },
              child: SizedBox(
                height: 115,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildDirectMessage(
                        'Customer 1', 'Buying Fruits', 'images/c3.png'),
                    _buildDirectMessage(
                        'Customer 2', 'Buying Vegetables', 'images/c2.png'),
                    _buildDirectMessage(
                        'Customer 3', 'Order Enquiry', 'images/c3.png'),
                    _buildDirectMessage(
                        'Customer 4', 'Product Feedback', 'images/c4.png'),
                    _buildDirectMessage(
                        'Customer 5', 'Bulk Purchase', 'images/c5.png'),
                    _buildDirectMessage(
                        'Customer 6', 'Discount Inquiry', 'images/c2.png'),
                    _buildDirectMessage(
                        'Customer 7', 'Order Issue', 'images/c3.png'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AllConversions()),
                  );
                },
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text1(
                       text1:   'Conversations',
                        size: 17,
                      ),
                    ),
                    _buildConversation(
                        context,
                        'Customer 1',
                        'Can I get an update on my order?',
                        'images/c3.png',
                        '12:34 pm',
                        1),
                    _buildConversation(
                        context,
                        'Customer 2',
                        'Is the product available?',
                        'images/c2.png',
                        '12:34 pm',
                        1),
                    _buildConversation(
                        context,
                        'Customer 3',
                        'Thank you for the quick response!',
                        'images/c3.png',
                        '12:34 pm',
                        0,
                        true),
                    _buildConversation(
                        context,
                        'Customer 4',
                        'I am looking for organic products.',
                        'images/c4.png',
                        '12:34 pm',
                        0,
                        true),
                    _buildConversation(
                        context,
                        'Customer 5',
                        'Can I get a discount on bulk purchase?',
                        'images/c5.png',
                        '12:34 pm',
                        1),
                    _buildConversation(
                        context,
                        'Customer 6',
                        'What is the current discount?',
                        'images/c3.png',
                        '12:34 pm',
                        1),
                    _buildConversation(
                        context,
                        'Customer 7',
                        'I have an issue with my order.',
                        'images/c2.png',
                        '12:34 pm',
                        0,
                        true),
                    _buildConversation(
                        context,
                        'Customer 1',
                        'Can you deliver by tomorrow?',
                        'images/c3.png',
                        '12:34 pm',
                        0,
                        true),
                    _buildConversation(
                        context,
                        'Customer 2',
                        'I need more details about the product.',
                        'images/c4.png',
                        '12:34 pm',
                        1),
                    _buildConversation(
                        context,
                        'Customer 3',
                        'Can you confirm the delivery time?',
                        'images/c3.png',
                        '12:34 pm',
                        0,
                        true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectMessage(String name, String subtitle, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          const SizedBox(height: 17),
          Stack(
            children: [
              Image.asset(imagePath),
            ],
          ),
          const SizedBox(height: 5),
          Text1(
           text1:  name,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text2(
            text2:    subtitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversation(
      BuildContext context,
      String name, String message, String imagePath, String time,
      [int unreadCount = 0, bool isYourTurn = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        color: Colors.white,
        elevation: 1,

        child: ListTile(
          leading: CircleAvatar(
            radius: 27,
            backgroundImage: AssetImage(imagePath),
          ),
          title: Text1(
           text1:  name,
          ),
          subtitle: Text2(text2:   message),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (unreadCount > 0)
                CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.text3Color,
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              if (isYourTurn)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.buttonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Your turn',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              Text2(
              text2:   time,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AllConversions()),
            );
            // Handle conversation tap
          },
        ),
      ),
    );
  }
}
