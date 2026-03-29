// ============ REELS PAGE ============
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'video_player_page.dart';

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              title: const Text('Health Reels',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              backgroundColor: isDark
                  ? const Color.fromRGBO(0, 0, 0, 0.5)
                  : const Color.fromRGBO(255, 255, 255, 0.5),
              elevation: 0,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [
                    Color.fromRGBO(
                      theme.colorScheme.tertiary.red,
                      theme.colorScheme.tertiary.green,
                      theme.colorScheme.tertiary.blue,
                      0.05,
                    ),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          GridView.count(
            padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 60, 16, 16),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
            children: const [
              _ReelCard(
                title: 'Breastfeeding Tips',
                isNew: true,
                color: Color.fromRGBO(3, 169, 244, 1),
                index: 0,
              ),
              _ReelCard(
                title: 'TB Awareness',
                color: Color.fromRGBO(139, 195, 74, 1),
                index: 1,
              ),
              _ReelCard(
                title: 'Vaccination Facts',
                color: Color.fromRGBO(255, 167, 38, 1),
                index: 2,
              ),
              _ReelCard(
                title: 'Hand Hygiene',
                color: Color.fromRGBO(233, 30, 99, 1),
                index: 3,
              ),
              _ReelCard(
                title: 'Nutrition for Kids',
                color: Color.fromRGBO(0, 150, 136, 1),
                index: 4,
              ),
              _ReelCard(
                title: 'Postnatal Care',
                isNew: true,
                color: Color.fromRGBO(156, 39, 176, 1),
                index: 5,
              ),
              _ReelCard(
                title: 'Diabetes Management',
                color: Color.fromRGBO(244, 67, 54, 1),
                index: 6,
              ),
              _ReelCard(
                title: 'Mental Health Basics',
                color: Color.fromRGBO(63, 81, 181, 1),
                index: 7,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReelCard extends StatefulWidget {
  final String title;
  final Color color;
  final bool isNew;
  final int index;

  const _ReelCard({
    required this.title,
    required this.color,
    this.isNew = false,
    required this.index,
  });

  @override
  State<_ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<_ReelCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VideoPlayerPage()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(
                      widget.color.red,
                      widget.color.green,
                      widget.color.blue,
                      0.6,
                    ),
                    Color.fromRGBO(
                      widget.color.red,
                      widget.color.green,
                      widget.color.blue,
                      0.3,
                    ),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromRGBO(255, 255, 255, 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(
                      widget.color.red,
                      widget.color.green,
                      widget.color.blue,
                      0.3,
                    ),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color.fromRGBO(0, 0, 0, 0),
                            const Color.fromRGBO(0, 0, 0, 0.7),
                          ],
                        ),
                      ),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                  if (widget.isNew)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(244, 67, 54, 1),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(244, 67, 54, 0.4),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'New',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (widget.index * 60).ms, duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }
}
