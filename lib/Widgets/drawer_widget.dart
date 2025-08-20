import 'package:flutter/material.dart';
import 'package:autopartsstoreapp/Screens/Settings/settings.dart';
import 'package:autopartsstoreapp/Screens/Wishlist/add_to_wishlist.dart';

import '../Screens/AvailablityCalendar/avaialblity_calendar.dart';
import '../Screens/BookMark/bookmark.dart';
import '../Screens/CartScreen/cart_screen.dart';
import '../Screens/Checkout/shipping_screen.dart';
import '../Screens/Favorite/favorite_screen.dart';
import '../Screens/Home/home_screen.dart';
import '../Screens/MessagesFlow/direct_messages.dart';
import '../Screens/Order/OrdersHistory/order_history_screen.dart';
import '../Screens/Profile/profile_screen.dart';
import '../Screens/Reviews/reviews.dart';
import '../Screens/Search/search_screen.dart';
import 'detailstext1.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String selectedMenuItem = ''; // Track the selected menu item

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 5, top: 10),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset('images/c3.png'),
            ),
            title: const Text(
              'Hey!',
              style: TextStyle(),
            ),
            subtitle: const Text1(text1: 'James Powell'),
          ),
          const SizedBox(height: 10.0),
          buildMenuItem(
            title: "Homepage",
            icon: Icons.home,
            onTap: () {
              navigateTo( HomePage());
            },
          ),
          const SizedBox(height: 3),
          buildMenuItem(
            title: "Cart",
            icon: Icons.shopping_cart,
            onTap: () {
              navigateTo(const CartScreen());
            },
          ),
          const SizedBox(height: 3),
          buildMenuItem(
            title: "Checkout",
            icon: Icons.payment, // Changed icon for Checkout
            onTap: () {
              navigateTo(const ShippingAddressScreen());
            },
          ),

          const SizedBox(height: 3),
          buildMenuItem(
            title: "Availability",
            icon: Icons.calendar_today, // Changed to calendar icon
            onTap: () {
              navigateTo(const AvailabilityCalendarScheduleScreen());
            },
          ),
          const SizedBox(height: 3),
          buildMenuItem(
            title: "Favorite",
            icon: Icons.favorite, // Kept the favorite icon
            onTap: () {
              navigateTo(const FavoriteScreen());
            },
          ),
          const SizedBox(height: 3),
          buildMenuItem(
            title: "Search Parts",
            icon: Icons.search, // Kept search icon
            onTap: () {
              navigateTo(const SearchScreen());
            },
          ),
          const SizedBox(height: 3),
          buildMenuItem(
            title: "Bookmark ",
            icon: Icons.bookmark, // Kept bookmark icon
            onTap: () {
              navigateTo(const BookmarkScreen());
            },
          ),const SizedBox(height: 3),
          buildMenuItem(
            title: "WishList ",
            icon: Icons.bookmark, // Kept bookmark icon
            onTap: () {
              navigateTo(const AddToWishlist());
            },
          ),

          const SizedBox(height: 3),
          buildMenuItem(
            title: "Orders",
            icon: Icons.list_alt, // Kept list icon for orders
            onTap: () {
              navigateTo(const OrdersHistory());
            },
          ),
          const SizedBox(height: 3),
          buildMenuItem(
            title: "Messages",
            icon: Icons.message, // Kept message icon
            onTap: () {
              navigateTo(const DirectMessages());
            },
          ),
          const SizedBox(height: 3),
          buildMenuItem(
            title: "Profile",
            icon: Icons.person, // Kept profile icon
            onTap: () {
              navigateTo(const ProfileScreen());
            },
          ),
          const SizedBox(height: 3),
          buildMenuItem(
            title: "Reviews",
            icon: Icons.rate_review, // Kept review icon
            onTap: () {
              navigateTo(const Reviews());
            },
          ),
          const SizedBox(height: 3),
          buildMenuItem(
            title: "Settings",
            icon: Icons.settings, // Kept settings icon
            onTap: () {
              navigateTo(const Settings());
            },
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 1),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.logout,
              color: Colors.redAccent,
              size: 20,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                color: Colors.redAccent,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    bool isSelected = title == selectedMenuItem;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(right: 30, top: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: const Border(),
        color: isSelected ? Colors.green : null, // Highlight selected item
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMenuItem = title;
          });
          onTap();
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.navigate_next,
              size: 20,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
