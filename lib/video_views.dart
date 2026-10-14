import 'package:flutter/material.dart';
import 'video_data.dart';
import 'video_player_embed.dart';
import 'study_data.dart';
import 'reader_view.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);
const purple = Color(0xFF6D5DD3);

/// Full in-app YouTube lecture player with embedded playback & notes
class VideoPlayerScreen extends StatefulWidget {
  final YouTubeVideoLecture lecture;

  const VideoPlayerScreen({super.key, required this.lecture});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _notesController = TextEditingController();
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.lecture;
    final matchingPdf = v.relatedPdfId != null ? StudyRepository.getById(v.relatedPdfId!) : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          v.category,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        actions: [
          IconButton(
            tooltip: 'Open in YouTube',
            icon: const Icon(Icons.open_in_new, color: Color(0xFFF2B84B)),
            onPressed: () => openYouTubeUrl(v.watchUrl),
          ),
          IconButton(
            tooltip: _isSaved ? 'Saved' : 'Save Lecture',
            icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              setState(() => _isSaved = !_isSaved);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isSaved ? 'Lecture saved to your watch list!' : 'Removed from saved list'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: navy,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Embedded YouTube Player
          Container(
            color: Colors.black,
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: buildYouTubeIFrame(v.youtubeVideoId),
            ),
          ),
          Container(
            color: const Color(0xFFF1F5F9),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: Colors.blueGrey),
                    SizedBox(width: 6),
                    Text(
                      'Tap video to Play/Pause & Fullscreen',
                      style: TextStyle(fontSize: 10.5, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => openYouTubeUrl(v.watchUrl),
                  child: const Row(
                    children: [
                      Icon(Icons.open_in_new, size: 11, color: Color(0xFFFF0000)),
                      SizedBox(width: 4),
                      Text(
                        'Watch on YouTube',
                        style: TextStyle(fontSize: 10.5, color: Color(0xFFFF0000), fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Toolbar & Video Meta
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Channel Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: navy,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          v.channelAvatar,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: navy,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${v.channel} • ${v.views} • ${v.duration}',
                              style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Quick Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF0000), // YouTube Red
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: const Text('Open on YouTube', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          onPressed: () => openYouTubeUrl(v.watchUrl),
                        ),
                      ),
                      if (matchingPdf != null) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.menu_book, size: 16),
                            label: const Text('Linked PDF Notes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DocumentReaderScreen(document: matchingPdf),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lecture Overview & Syllabus:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: navy),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          v.description,
                          style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tabs: Chapters, Revision Notes, My Notes
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: navy,
                      unselectedLabelColor: Colors.blueGrey,
                      indicatorColor: blue,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      tabs: const [
                        Tab(text: '⏱ Timestamps'),
                        Tab(text: '📝 Key Points'),
                        Tab(text: '✍ My Notes'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tab Views Content
                  SizedBox(
                    height: 280,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: Timestamps
                        ListView.separated(
                          itemCount: v.keyTimestamps.length,
                          separatorBuilder: (_, i) => const Divider(height: 12),
                          itemBuilder: (ctx, i) {
                            final ts = v.keyTimestamps[i];
                            return Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 16, color: blue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ts,
                                    style: const TextStyle(fontSize: 12, color: navy, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        // Tab 2: Revision Notes
                        ListView.separated(
                          itemCount: v.revisionNotes.length,
                          separatorBuilder: (_, i) => const Divider(height: 12),
                          itemBuilder: (ctx, i) {
                            final note = v.revisionNotes[i];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: green, fontSize: 16, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    note,
                                    style: const TextStyle(fontSize: 12, color: navy, height: 1.35),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        // Tab 3: My Notes
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Write your personal study notes while watching:',
                              style: TextStyle(fontSize: 11.5, color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: TextField(
                                controller: _notesController,
                                maxLines: null,
                                expands: true,
                                decoration: InputDecoration(
                                  hintText: 'Type your lecture summary, formulas, or questions here...',
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                ),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: navy,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.save, size: 16),
                                label: const Text('Save My Lecture Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Your study notes have been saved locally!'),
                                      backgroundColor: green,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The Video Lectures Browse & Search View
class VideoLecturesView extends StatefulWidget {
  const VideoLecturesView({super.key});

  @override
  State<VideoLecturesView> createState() => _VideoLecturesViewState();
}

class _VideoLecturesViewState extends State<VideoLecturesView> {
  String selectedCategory = 'All Subjects';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var list = VideoLibraryData.getByCategory(selectedCategory);

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((v) {
        return v.title.toLowerCase().contains(q) ||
            v.channel.toLowerCase().contains(q) ||
            v.category.toLowerCase().contains(q) ||
            v.description.toLowerCase().contains(q);
      }).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input
        TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search YouTube classes (e.g. Polity, Maths, Khan GS)...',
            hintStyle: const TextStyle(fontSize: 12.5, color: Colors.blueGrey),
            prefixIcon: const Icon(Icons.search, color: blue, size: 20),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: blue, width: 2)),
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: VideoLibraryData.categories.map((cat) {
              final isSelected = selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(cat),
                  labelStyle: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                    color: isSelected ? Colors.white : navy,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: navy,
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: isSelected ? navy : const Color(0xFFCBD5E1)),
                  ),
                  onSelected: (val) => setState(() => selectedCategory = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),

        // Video Count Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${list.length} Curated YouTube Masterclasses',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: navy),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.play_circle_fill, size: 12, color: Color(0xFFFF0000)),
                  SizedBox(width: 4),
                  Text('HD Video', style: TextStyle(color: Color(0xFFFF0000), fontSize: 10, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Video Cards List
        if (list.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Column(
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.blueGrey),
                SizedBox(height: 10),
                Text('No video lectures found', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                SizedBox(height: 4),
                Text('Try searching for another keyword or subject category.', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
              ],
            ),
          )
        else
          ...list.map((video) => VideoLectureCard(lecture: video)),
      ],
    );
  }
}

/// The Card Widget for each YouTube Lecture
class VideoLectureCard extends StatelessWidget {
  final YouTubeVideoLecture lecture;

  const VideoLectureCard({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPlayerScreen(lecture: lecture),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Stack with Play Icon & Duration
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      lecture.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: navy,
                        child: Center(
                          child: Text(
                            lecture.channelAvatar,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Dark gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      gradient: LinearGradient(
                        colors: [Colors.black.withValues(alpha: 0.3), Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Center Play Button
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000).withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                    ),
                  ),
                ),

                // Category & Language Tag (Top Left)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: navy.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lecture.category,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),

                // Duration Tag (Bottom Right)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time, color: Colors.white, size: 11),
                        const SizedBox(width: 4),
                        Text(
                          lecture.duration,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecture.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                      color: navy,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        lecture.channelAvatar,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lecture.channel,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: blue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        lecture.views,
                        style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_stories, size: 14, color: green),
                          const SizedBox(width: 4),
                          Text(
                            '${lecture.revisionNotes.length} Exam Points',
                            style: const TextStyle(fontSize: 11, color: green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Text('Watch Class', style: TextStyle(color: blue, fontSize: 11.5, fontWeight: FontWeight.w900)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios, size: 10, color: blue),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
