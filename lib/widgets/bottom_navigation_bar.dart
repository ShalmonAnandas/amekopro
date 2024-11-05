import 'package:amekopro/features/chat/chat_controller.dart';
import 'package:amekopro/features/chat/chat_ui.dart';
import 'package:amekopro/features/chat/create_new_chat.dart';
import 'package:amekopro/features/profile/profile_ui.dart';
import 'package:amekopro/utils/hex_color.dart';
import 'package:amekopro/widgets/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

/// The main home screen widget for the app that provides navigation between different sections.
///
/// This widget implements a bottom navigation bar with scrollable tabs and a page view
/// to switch between different sections of the app including:
/// - Home
/// - Anime
/// - KDrama
/// - Books
/// - Manga
/// - Profile
///
/// The navigation bar automatically scrolls to keep the selected tab visible and
/// provides visual feedback through colors and animations when switching sections.
class AppHomeUi extends StatefulWidget {
  const AppHomeUi({super.key});

  @override
  State<AppHomeUi> createState() => _AppHomeUiState();
}

/// The state class for [AppHomeUi].
///
/// Manages the state and logic for:
/// - Page navigation using [PageController]
/// - Bottom navigation bar scrolling using [ScrollController]
/// - Selected tab index tracking
/// - Navigation animations and visual feedback
class _AppHomeUiState extends State<AppHomeUi> {
  final PageController controller = PageController();
  final ScrollController navScrollController = ScrollController();
  int _selectedIndex = 0;

  /// Scrolls the navigation bar to ensure the selected item is visible.
  ///
  /// This method calculates the optimal scroll position to show the selected tab,
  /// taking into account:
  /// - The viewport width
  /// - Number of visible items
  /// - Current scroll position
  /// - Selected item position
  ///
  /// The scroll animation uses an ease in/out curve over 300ms.
  void _scrollToSelectedItem(int index) {
    // Get the viewport width
    final viewportWidth = MediaQuery.of(context).size.width;
    // Calculate how many items are visible
    final visibleItems = (viewportWidth / 100).floor();
    // Get the current scroll position
    final currentScroll = navScrollController.offset;
    // Calculate the start and end indices of visible items
    final startVisible = (currentScroll / 100).floor();
    final endVisible = startVisible + visibleItems - 1;

    // Only scroll if the selected item is not in view
    if (index < startVisible || index > endVisible) {
      // Calculate target scroll position to center the selected item if possible
      final targetScroll = math.max(
        0.0, // Prevent negative scroll
        math.min(
          index * 100.0 - (viewportWidth - 100) / 2, // Center the item
          (6 * 100.0) - viewportWidth, // Prevent scrolling past the end
        ),
      );

      navScrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Controller initialization
    Get.put(ChatController());

    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 7,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
          controller: navScrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildNavItem('assets/home.png', 'Home', 0),
              _buildNavItem('assets/anime.png', 'Anime', 1),
              _buildNavItem('assets/kdrama.png', 'KDrama', 2),
              _buildNavItem('assets/book.png', 'Books', 3),
              _buildNavItem('assets/manga.png', 'Manga', 4),
              _buildNavItem('assets/user.png', 'Profile', 5),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _scrollToSelectedItem(index);
        },
        children: const [
          CreateNewChat(),
          Center(child: AmekoText(text: "Anime")),
          Center(child: AmekoText(text: "KDrama")),
          Center(child: AmekoText(text: "Books")),
          Center(child: AmekoText(text: "Manga")),
          ProfileUi(),
        ],
      ),
    );
  }

  /// Builds a navigation item for the bottom bar.
  ///
  /// Each item consists of an icon and label that change color when selected.
  /// Tapping an item will:
  /// - Update the selected index
  /// - Animate to the corresponding page
  /// - Scroll the navigation bar if needed
  ///
  /// Parameters:
  /// - [iconPath]: Asset path for the item's icon
  /// - [label]: Text label shown below the icon
  /// - [index]: Index of this item in the navigation bar
  Widget _buildNavItem(String iconPath, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 100,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            _scrollToSelectedItem(index);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: isSelected ? HexColor("D9E0A4") : Colors.grey.shade500,
              ),
              const SizedBox(height: 4),
              AmekoText(
                text: label,
                fontSize: 12,
                color: isSelected ? HexColor("D9E0A4") : Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    navScrollController.dispose();
    controller.dispose();
    super.dispose();
  }
}
