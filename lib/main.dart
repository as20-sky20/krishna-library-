import 'package:flutter/material.dart';
import 'study_data.dart';
import 'reader_view.dart';
import 'admin_data.dart';
import 'admin_views.dart';
import 'payment_view.dart';
import 'video_data.dart';
import 'video_views.dart';
import 'requests_and_expenses_views.dart';
import 'id_card_view.dart';
import 'quiz_data.dart';
import 'quiz_view.dart';
import 'whatsapp_reminder_view.dart';
import 'ai_search_view.dart';
import 'login_view.dart';
import 'study_material_views.dart';

void main() => runApp(const App());

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const purple = Color(0xFF6D5DD3);
const amber = Color(0xFFE6A62C);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isLoggedIn = false;
  bool _isAdmin = false;
  MemberRecord? _currentMember;

  void _onLoginSuccess({required bool isAdmin, MemberRecord? member}) {
    setState(() {
      _isLoggedIn = true;
      _isAdmin = isAdmin;
      _currentMember = member;
    });
  }

  void _onSignOut() {
    setState(() {
      _isLoggedIn = false;
      _isAdmin = false;
      _currentMember = null;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KRISHNA LIBRARY',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F8FC),
          colorScheme: ColorScheme.fromSeed(seedColor: blue),
        ),
        home: _isLoggedIn
            ? Shell(
                initialIsAdmin: _isAdmin,
                loggedInMember: _currentMember,
                onSignOut: _onSignOut,
              )
            : LoginScreen(onLoginSuccess: _onLoginSuccess),
      );
}

class Shell extends StatefulWidget {
  final bool initialIsAdmin;
  final MemberRecord? loggedInMember;
  final VoidCallback onSignOut;

  const Shell({
    super.key,
    this.initialIsAdmin = false,
    this.loggedInMember,
    required this.onSignOut,
  });

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;
  late bool admin;
  MemberRecord? _activeMember;

  @override
  void initState() {
    super.initState();
    admin = widget.initialIsAdmin;
    _activeMember = widget.loggedInMember;
  }

  MemberRecord get currentMember =>
      _activeMember ??
      AdminData.getMemberById('KL-0248') ??
      AdminData.members.first;

  int get mySeat => currentMember.seatNo;

  Set<int> get busy => AdminData.members.map((m) => m.seatNo).toSet();

  @override
  Widget build(BuildContext context) {
    final pages = admin
        ? [
            Admin(
              jump: (i) => setState(() => index = i),
              refresh: () => setState(() {}),
              onSignOut: widget.onSignOut,
            ),
            Seats(
              my: mySeat,
              busy: busy,
              onSelect: select,
              isAdmin: true,
              refresh: () => setState(() {}),
            ),
            Materials(
              isAdmin: true,
              onStateChange: () => setState(() {}),
            ),
            Alerts(
              isAdmin: true,
              onRefresh: () => setState(() {}),
            ),
            Profile(
              admin: true,
              currentMember: currentMember,
              switchMode: () => setState(() => admin = false),
              jump: (i) => setState(() => index = i),
              refresh: () => setState(() {}),
              onSignOut: widget.onSignOut,
            ),
          ]
        : [
            Home(
              available: 27 - busy.length,
              occupied: busy.length,
              my: mySeat,
              member: currentMember,
              jump: (i) => setState(() => index = i),
              refresh: () => setState(() {}),
            ),
            Seats(
              my: mySeat,
              busy: busy,
              onSelect: select,
              isAdmin: false,
              refresh: () => setState(() {}),
            ),
            Materials(
              isAdmin: false,
              onStateChange: () => setState(() {}),
            ),
            Alerts(
              isAdmin: false,
              onRefresh: () => setState(() {}),
            ),
            Profile(
              admin: false,
              currentMember: currentMember,
              switchMode: () => setState(() => admin = true),
              jump: (i) => setState(() => index = i),
              refresh: () => setState(() {}),
              onSignOut: widget.onSignOut,
            ),
          ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: index, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event_seat_outlined), label: 'Seats'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Material'),
          NavigationDestination(icon: Icon(Icons.notifications_none), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  void select(int seat) {
    if (busy.contains(seat) && seat != mySeat) {
      showSeatOccupantDetails(context, seat, isAdmin: admin, onStateChange: () => setState(() {}));
      return;
    }
    setState(() {
      currentMember.seatNo = seat;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Seat ${seat.toString().padLeft(2, '0')} selected as My Seat.')),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
    required this.available,
    required this.occupied,
    required this.my,
    this.member,
    required this.jump,
    required this.refresh,
  });

  final int available, occupied, my;
  final MemberRecord? member;
  final ValueChanged<int> jump;
  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) {
    final activeMember = member ?? AdminData.getMemberById('KL-0248') ?? AdminData.members.first;
    final isPaid = activeMember.feeStatus == 'Paid';

    return Page(
      child: [
        const Brand(),
        const SizedBox(height: 22),
        Text('Good morning, ${activeMember.name.split(' ').first}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: navy)),
        const Text('Your focused space is ready for you.', style: TextStyle(color: Colors.blueGrey)),
        const SizedBox(height: 18),
        const HeroBanner(),
        const SizedBox(height: 20),
        Row(children: [
          Stat('Available', '$available', green),
          Stat('Occupied', '$occupied', red),
          Stat('My seat', activeMember.seatNo.toString().padLeft(2, '0'), purple),
        ]),
        const SizedBox(height: 18),
        KrishnaAiSearchBar(
          onTap: () => showKrishnaAiSearchSheet(context),
        ),
        const SizedBox(height: 22),
        const SectionTitle('Quick actions'),
        const SizedBox(height: 12),
        Row(children: [
          ActionItem(
            'Pay Fees',
            Icons.qr_code_scanner,
            () => showFeePaymentSheet(context, onPaymentSuccess: refresh),
          ),
          ActionItem('Seats', Icons.event_seat, () => jump(1)),
          ActionItem('Material', Icons.menu_book, () => jump(2)),
          ActionItem(
            'AI Guru',
            Icons.auto_awesome,
            () => showKrishnaAiSearchSheet(context),
          ),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          ActionItem(
            'Daily Quiz',
            Icons.quiz_outlined,
            () => showDailyQuizSheet(context, onStateChange: refresh),
          ),
          ActionItem(
            'Digital ID',
            Icons.badge_outlined,
            () => showStudentIdCardSheet(context, member: activeMember),
          ),
          ActionItem(
            'Shift / Desk',
            Icons.swap_horiz,
            () => showSeatChangeRequestSheet(context, onStateChange: refresh),
          ),
          ActionItem(
            'Receipt Slip',
            Icons.receipt_long,
            () => showMemberReceiptSheet(context, member: activeMember),
          ),
        ]),
        const SizedBox(height: 24),
        SectionTitle('Membership overview', action: isPaid ? 'ACTIVE' : 'DUE'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [navy, Color(0xFF1E3A5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: navy.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: Color(0xFFF2B84B), size: 22),
                      const SizedBox(width: 8),
                      Text(
                        activeMember.plan,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPaid ? green : amber,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isPaid ? 'PAID & ACTIVE' : 'FEE DUE (₹${activeMember.amount})',
                      style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '₹${activeMember.amount} / month • Seat ${activeMember.seatNo.toString().padLeft(2, '0')} • Valid until ${activeMember.dueDate}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.qr_code_scanner, size: 16),
                        label: const Text('Pay / Renew Online', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                        onPressed: () => showFeePaymentSheet(context, onPaymentSuccess: refresh),
                      ),
                    ),
                    const SizedBox(width: 6),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white30),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.badge_outlined, size: 16),
                      label: const Text('ID Pass', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () => showStudentIdCardSheet(context, member: activeMember),
                    ),
                    const SizedBox(width: 6),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white30),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.receipt_long, size: 16),
                      label: const Text('Slip', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () => showMemberReceiptSheet(context, member: activeMember),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Latest from the library'),
          const SizedBox(height: 10),
          Notice(
            Icons.quiz_outlined,
            'Daily 10-Min Booster Quiz Live (मॉक टेस्ट दें)',
            'Today\'s 10-question practice test in Hindi & English is live. Test yourself & check Hall Rank!',
            onTap: () => showDailyQuizSheet(context, onStateChange: refresh),
          ),
          const SizedBox(height: 9),
          Notice(
            Icons.badge_outlined,
            'Official Student Digital ID Card (पहचान पत्र)',
            'Your official Krishna Library gate pass with barcode and Admin Kamal\'s stamp is ready to download.',
            onTap: () => showStudentIdCardSheet(context, member: activeMember),
          ),
          const SizedBox(height: 9),
          Notice(
            Icons.receipt_long_outlined,
            'My Fee Receipt & Active Plan',
            'Your monthly membership (₹${activeMember.amount}) is ${activeMember.feeStatus.toLowerCase()}. Tap to view fee receipt.',
            onTap: () => showMemberReceiptSheet(context, member: activeMember),
          ),
          const SizedBox(height: 9),
          Notice(
            Icons.auto_stories_outlined,
            'Hindi & English Study Packs Uploaded',
            'Authentic PDF modules for SSC, Maths, GK & Vyakaran are ready to read.',
            onTap: () => jump(2),
          ),
          const SizedBox(height: 9),
          Notice(
            Icons.play_circle_fill,
            'YouTube Video Classes Integrated (यहीं देखें)',
            'Watch free YouTube video lectures for SSC, Maths, Polity & GK directly inside the app.',
            onTap: () => jump(2),
          ),
          const SizedBox(height: 9),
          Notice(
            Icons.swap_horiz,
            'Request Shift or Desk Change (सीट व शिफ्ट अर्जी)',
            'Need a different desk or want to upgrade to Full Day? Submit request directly to Admin Kamal.',
            onTap: () => showSeatChangeRequestSheet(context, onStateChange: refresh),
          ),
        ],
      );
  }
}

class Seats extends StatelessWidget {
  const Seats({
    super.key,
    required this.my,
    required this.busy,
    required this.onSelect,
    this.isAdmin = false,
    this.refresh,
  });

  final int my;
  final Set<int> busy;
  final ValueChanged<int> onSelect;
  final bool isAdmin;
  final VoidCallback? refresh;

  @override
  Widget build(BuildContext context) => Page(
        child: [
          const Header('Study seats & Occupant Data', '27 fixed study desks. Tap any occupied seat to view member details.'),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F3FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: blue, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isAdmin
                        ? '🟢 Available: ${27 - busy.length}   🔴 Occupied: ${busy.length}   🟣 My Seat: S${my.toString().padLeft(2, '0')}\nAdmin Mode: Tap occupied seats to manage fees, plans & digital ID passes.'
                        : '🟢 Available: ${27 - busy.length}   🔴 Occupied: ${busy.length}   🟣 My Seat: S${my.toString().padLeft(2, '0')}\nTap occupied seats to see student name and study shift.',
                    style: const TextStyle(color: blue, fontWeight: FontWeight.w600, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 27,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (_, i) {
              final seat = i + 1;
              final mine = seat == my;
              final occupied = busy.contains(seat) && !mine;
              final member = AdminData.getMemberBySeat(seat);
              final color = mine ? purple : occupied ? red : green;

              return InkWell(
                onTap: () {
                  if (occupied || mine) {
                    showSeatOccupantDetails(context, seat, isAdmin: isAdmin, onStateChange: refresh);
                  } else {
                    onSelect(seat);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .1),
                    border: Border.all(color: color.withValues(alpha: .4)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(mine ? Icons.bookmark : Icons.event_seat, color: color, size: 22),
                      const SizedBox(height: 2),
                      Text(
                        seat.toString().padLeft(2, '0'),
                        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      Text(
                        mine
                            ? 'My seat'
                            : occupied
                                ? (member != null ? member.name.split(' ').first : 'Occupied')
                                : 'Available',
                        style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (occupied && member != null && isAdmin)
                        Text(
                          member.feeStatus == 'Paid' ? 'Paid ✓' : 'Due ⚠',
                          style: TextStyle(
                            color: member.feeStatus == 'Paid' ? green : red,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
}

class Materials extends StatefulWidget {
  final bool isAdmin;
  final VoidCallback? onStateChange;

  const Materials({super.key, this.isAdmin = false, this.onStateChange});

  @override
  State<Materials> createState() => _MaterialsState();
}

class _MaterialsState extends State<Materials> {
  String activeTab = 'pdf'; // 'pdf' or 'video'
  String selectedLanguage = 'All'; // 'All', 'Hindi', 'English'
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  final categories = const [
    'All',
    'Exam Material',
    'Current Affairs',
    'GK',
    'Maths',
    'Reasoning',
    'English',
    'Hindi',
    'Computer',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final docs = StudyRepository.filter(
      language: selectedLanguage,
      category: selectedCategory,
      search: searchQuery,
    );

    return Page(
      child: [
        Header(
          activeTab == 'video'
              ? 'YouTube Video Classes'
              : activeTab == 'quiz'
                  ? 'Daily Exam Booster Quiz'
                  : 'Study Material & PDFs',
          activeTab == 'video'
              ? 'Watch curated YouTube lectures for SSC, Maths, Polity & GK in-app.'
              : activeTab == 'quiz'
                  ? 'Daily 10-question practice test with instant solutions & Hall rank.'
                  : 'Authentic Hindi & English notes with full reader view.',
        ),
        const SizedBox(height: 18),

        // Master Switcher: PDF Notes vs YouTube Videos vs Daily Quiz
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => activeTab = 'pdf'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: activeTab == 'pdf' ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: activeTab == 'pdf'
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4)]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 16, color: activeTab == 'pdf' ? red : Colors.blueGrey),
                        const SizedBox(width: 5),
                        Text(
                          'PDFs (${StudyRepository.documents.length})',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: activeTab == 'pdf' ? navy : Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => activeTab = 'video'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: activeTab == 'video' ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: activeTab == 'video'
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4)]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_circle_fill, size: 16, color: activeTab == 'video' ? const Color(0xFFFF0000) : Colors.blueGrey),
                        const SizedBox(width: 5),
                        Text(
                          'Videos (${VideoLibraryData.lectures.length})',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: activeTab == 'video' ? navy : Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => activeTab = 'quiz'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: activeTab == 'quiz' ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: activeTab == 'quiz'
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4)]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.quiz, size: 16, color: activeTab == 'quiz' ? purple : Colors.blueGrey),
                        const SizedBox(width: 5),
                        Text(
                          'Quiz (10 Qs)',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: activeTab == 'quiz' ? navy : Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        if (activeTab == 'video') ...[
          const VideoLecturesView(),
        ] else if (activeTab == 'quiz') ...[
          _buildQuizMaterialsTab(context),
        ] else ...[
          // Language Filter Selector Bar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                _buildLangTab('All', '🌐 All PDFs (${StudyRepository.documents.length})'),
                _buildLangTab('Hindi', '🇮🇳 हिन्दी माध्यम'),
                _buildLangTab('English', '🇬🇧 English Medium'),
              ],
            ),
          ),
          const SizedBox(height: 14),

        // Search Bar
        TextField(
          controller: searchController,
          onChanged: (val) => setState(() => searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search Hindi or English topics, chapters, formulas...',
            prefixIcon: const Icon(Icons.search, color: navy),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      searchController.clear();
                      setState(() => searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 14),

        // Subject Category Filter Chips
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, i) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final isSel = selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSel,
                selectedColor: navy,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : navy,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onSelected: (_) => setState(() => selectedCategory = cat),
              );
            },
          ),
        ),
        const SizedBox(height: 18),

        // List Header with count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${docs.length} PDFs Available',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: navy),
            ),
            Text(
              selectedLanguage == 'Hindi'
                  ? 'हिन्दी भाषा'
                  : selectedLanguage == 'English'
                      ? 'English Language'
                      : 'All Languages',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: blue),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (widget.isAdmin) ...[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.upload_file_rounded, size: 20),
              label: const Text(
                '+ Add New Study Material / PDF (नया नोट्स व PDF जोड़ें)',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
              ),
              onPressed: () => showAddStudyMaterialDialog(
                context,
                onSaved: () {
                  setState(() {});
                  widget.onStateChange?.call();
                },
              ),
            ),
          ),
        ],

        // Document Cards List
        if (docs.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const Icon(Icons.search_off, size: 48, color: Colors.grey),
                const SizedBox(height: 10),
                const Text('No study materials found', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                const SizedBox(height: 4),
                const Text('Try selecting a different language or subject category.', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
              ],
            ),
          )
        else
          ...docs.map((doc) => MaterialCard(
                document: doc,
                isAdmin: widget.isAdmin,
                onDelete: () {
                  setState(() {});
                  widget.onStateChange?.call();
                },
              )),
        ],
      ],
    );
  }

  Widget _buildLangTab(String langKey, String label) {
    final isSelected = selectedLanguage == langKey;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedLanguage = langKey),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? (langKey == 'Hindi' ? green : (langKey == 'English' ? blue : navy)) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : navy,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildQuizMaterialsTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [navy, Color(0xFF1B3A57)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFF2B84B), borderRadius: BorderRadius.circular(6)),
                    child: const Text('DAILY BOOSTER #104', style: TextStyle(color: navy, fontSize: 9.5, fontWeight: FontWeight.w900)),
                  ),
                  const Text(QuizRepository.quizDate, style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Today\'s 10-Minute Full Exam Mock Test',
                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                '10 Authentic bilingual MCQs on Polity, Maths, History, Science, Reasoning & Hindi Vyakaran.',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2B84B),
                    foregroundColor: navy,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 20),
                  label: Text(
                    QuizRepository.hasAttemptedToday
                        ? 'Retake Test / View Score (${QuizRepository.lastScore}/10)'
                        : 'Start Test Now (टेस्ट शुरू करें)',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                  ),
                  onPressed: () => showDailyQuizSheet(context, onStateChange: () => setState(() {})),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Study Hall Leaderboard', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: navy)),
            TextButton.icon(
              icon: const Icon(Icons.open_in_new, size: 14),
              label: const Text('Open Quiz Hub', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
              onPressed: () => showDailyQuizSheet(context, onStateChange: () => setState(() {})),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...QuizRepository.leaderboard.take(5).map((r) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: r.rank == 1 ? const Color(0xFFF2B84B) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: r.rank == 1 ? const Color(0xFFF2B84B) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#${r.rank}',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: r.rank == 1 ? Colors.white : navy),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy)),
                        Text('Seat S-${r.seatNo.toString().padLeft(2, '0')} • ${r.exam}', style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                  Text('${r.score}/10', style: const TextStyle(fontWeight: FontWeight.w900, color: green, fontSize: 13.5)),
                ],
              ),
            )),
      ],
    );
  }
}

class MaterialCard extends StatelessWidget {
  const MaterialCard({
    super.key,
    required this.document,
    this.isAdmin = false,
    this.onDelete,
  });

  final StudyDocument document;
  final bool isAdmin;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isHindi = document.language == 'Hindi';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DocumentReaderScreen(document: document)),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PDF Icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 54,
                    decoration: BoxDecoration(
                      color: red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: red.withValues(alpha: 0.3)),
                    ),
                    child: const Center(
                      child: Icon(Icons.picture_as_pdf, color: red, size: 28),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    left: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'PDF',
                        style: TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isHindi ? green : blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isHindi ? 'हिन्दी' : 'ENGLISH',
                            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            document.category,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: navy),
                          ),
                        ),
                        if (document.localFileName != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: red.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.attach_file, size: 10, color: red),
                                const SizedBox(width: 2),
                                Text(
                                  document.localFileSize != null ? 'PDF • ${document.localFileSize}' : 'PDF File',
                                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: red),
                                ),
                              ],
                            ),
                          ),
                        ] else if (document.pdfUrl != null && document.pdfUrl!.trim().isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: green.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.link, size: 10, color: green),
                                SizedBox(width: 2),
                                Text(
                                  'Drive / Link',
                                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title
                    Text(
                      document.title,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: navy, height: 1.3),
                    ),
                    const SizedBox(height: 6),

                    // Details & Read CTA
                    Row(
                      children: [
                        Text(
                          '${document.pages} Pages • ${document.readTime}',
                          style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: blue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isHindi ? 'खोलकर पढ़ें' : 'Open & Read',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blue),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 10, color: blue),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (isAdmin)
                IconButton(
                  tooltip: 'हटाएं (Delete PDF)',
                  icon: const Icon(Icons.delete_outline, color: red, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        title: const Row(
                          children: [
                            Icon(Icons.delete_forever, color: red),
                            SizedBox(width: 8),
                            Text('Delete PDF?'),
                          ],
                        ),
                        content: Text('क्या आप "${document.title}" को लाइब्रेरी से हटाना चाहते हैं?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('रद्द करें'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: red, foregroundColor: Colors.white),
                            onPressed: () {
                              StudyRepository.removeDocument(document.id);
                              Navigator.pop(ctx);
                              onDelete?.call();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('"${document.title}" हटा दिया गया!')),
                              );
                            },
                            child: const Text('हटाएं'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Alerts extends StatelessWidget {
  const Alerts({super.key, this.isAdmin = false, this.onRefresh});
  final bool isAdmin;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final alertsList = AdminData.alerts;

    return Page(
      child: [
        Header(
          isAdmin ? 'Admin Alerts & Payment Feed' : 'Notifications & Updates',
          isAdmin ? 'Live transaction receipts & system notices' : 'Stay in the loop at Krishna Library.',
        ),
        const SizedBox(height: 20),
        ...alertsList.map((alert) {
          final isPay = alert.isPayment;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isPay ? green.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPay ? green.withValues(alpha: 0.35) : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isPay ? green : blue).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPay ? Icons.payments_outlined : (alert.icon == 'book' ? Icons.auto_stories : Icons.event_seat),
                    color: isPay ? green : blue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              alert.title,
                              style: const TextStyle(fontWeight: FontWeight.w800, color: navy, fontSize: 13.5),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              alert.time,
                              style: const TextStyle(fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        alert.message,
                        style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey, height: 1.35),
                      ),
                      if (isPay) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, size: 12, color: green),
                                  SizedBox(width: 4),
                                  Text(
                                    'DIRECT TRANSFERRED TO ADMIN KAMAL',
                                    style: TextStyle(color: green, fontSize: 9.5, fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.admin,
    this.currentMember,
    required this.switchMode,
    required this.jump,
    required this.refresh,
    required this.onSignOut,
  });

  final bool admin;
  final MemberRecord? currentMember;
  final VoidCallback switchMode;
  final ValueChanged<int> jump;
  final VoidCallback refresh;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final activeMember = currentMember ?? AdminData.getMemberById('KL-0248') ?? AdminData.members.first;

    return Page(
        child: [
          Header(admin ? 'Admin Profile' : 'Student Profile', admin ? 'Chief Administrator Console' : 'Your personal library account.'),
          const SizedBox(height: 20),

          // Identity Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(22)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: admin ? const Color(0xFF1E3A5A) : const Color(0xFF2B5273),
                  child: admin
                      ? const Icon(Icons.shield_outlined, color: Color(0xFFF2B84B), size: 36)
                      : Text(
                          activeMember.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                          style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800),
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  admin ? '${AdminData.adminName} (Admin)' : activeMember.name,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  admin ? 'Senior Library Director • KL-ADMIN-01' : 'Member ID • ${activeMember.id} • Seat S-${activeMember.seatNo.toString().padLeft(2, '0')}',
                  style: TextStyle(color: admin ? const Color(0xFFF2B84B) : Colors.white70, fontSize: 13, fontWeight: admin ? FontWeight.bold : FontWeight.normal),
                ),
                if (admin) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)),
                    child: const Text('SUPER ADMIN • BRANCH 01 • FULL PERMISSIONS', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Details List
          if (admin) ...[
            const Info(label: 'Designation', value: 'Library Director & Seat Master'),
            const Info(label: 'Branch Location', value: 'Branch 01, Main Road'),
            Info(label: 'Capacity', value: '${AdminData.totalSeats} Study Desks'),
            Info(label: 'Occupancy', value: '${AdminData.totalOccupied} Occupied / ${AdminData.availableSeats} Available'),
            Info(label: 'Fee Revenue', value: '₹${AdminData.totalRevenueCollected} Collected'),
            Info(label: 'Pending Dues', value: '₹${AdminData.totalPendingAmount} (${AdminData.pendingCount} Members)'),
            Info(label: 'Study Materials', value: '${StudyRepository.documents.length} Published PDFs & Notes'),
            Info(label: 'Total Expenses', value: '₹${AdminData.totalExpenses} (${AdminData.expenses.length} Bills)'),
            Info(label: 'Net Monthly Profit', value: '₹${AdminData.netProfit}'),
            Info(label: 'Pending Requests', value: '${AdminData.pendingRequestsCount} Awaiting Review'),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: purple),
              title: Text('Student Requests (${AdminData.pendingRequestsCount} Pending)', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Approve desk swap & shift change requests'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showAdminRequestsSheet(context, onStateChange: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined, color: green),
              title: const Text('Library Expenses & Net Profit (खर्च एवं लाभ)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Expenses: ₹${AdminData.totalExpenses} • Net Profit: ₹${AdminData.netProfit}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showExpenseManagerSheet(context, onStateChange: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.payments_outlined, color: amber),
              title: const Text('Fee Management (फीस रिकॉर्ड)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${AdminData.pendingCount} students have dues pending'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showFeeManagementSheet(context, onStateChange: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFF25D366)),
              title: Text('WhatsApp Fee Notice (${AdminData.pendingCount} Overdue)', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Send 1-click WhatsApp payment reminders with UPI link'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showBatchWhatsAppReminderSheet(context, onSent: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.upload_file_rounded, color: red),
              title: const Text('Add & Manage Study PDFs (नोट्स व PDF)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${StudyRepository.documents.length} study modules published • Tap to add new'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showAddStudyMaterialDialog(context, onSaved: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner, color: purple),
              title: const Text('Online Payments Received (ऑनलाइन पेमेंट)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${AdminData.transactions.length} online payments direct to Admin Kamal UPI'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showFeeManagementSheet(context, onStateChange: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.event_seat_outlined, color: blue),
              title: const Text('Seat Allotment Master (सीटें)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('View and assign 27 study desks'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => jump(1),
            ),
            ListTile(
              leading: const Icon(Icons.badge_outlined, color: blue),
              title: const Text('Student ID Cards & Passes (पहचान पत्र)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Inspect & print student digital passes with barcode'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showStudentIdCardSheet(context),
            ),
            ListTile(
              leading: const Icon(Icons.quiz_outlined, color: purple),
              title: const Text('Daily Exam Booster Quiz & Rankers', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('View today\'s 10-min test & hall leaderboard'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showDailyQuizSheet(context, onStateChange: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner_outlined, color: green),
              title: const Text('Payment QR & UPI Settings (पर्सनल बारकोड / QR)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(AdminData.useCustomQr
                  ? 'Custom QR Active: ${AdminData.adminUpiId}'
                  : 'UPI: ${AdminData.adminUpiId} • Tap to set personal QR'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showCustomQrSettingsDialog(context, onSaved: refresh),
            ),
          ] else ...[
            Info(label: 'Assigned seat', value: '${activeMember.seatNo.toString().padLeft(2, '0')} • Active'),
            Info(label: 'Membership', value: activeMember.plan),
            Info(label: 'Shift Timing', value: activeMember.shift),
            Info(label: 'Expires', value: activeMember.dueDate),
            Info(label: 'Payment', value: '${activeMember.feeStatus} • INR ${activeMember.amount} (${activeMember.paymentMode})'),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.badge_outlined, color: blue),
              title: const Text('My Digital ID Card (पहचान पत्र)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Official Krishna Library pass with barcode & Admin seal'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showStudentIdCardSheet(context, member: activeMember),
            ),
            ListTile(
              leading: const Icon(Icons.quiz_outlined, color: purple),
              title: const Text('Daily Mock Test & Rank (क्विज व स्कोर)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(QuizRepository.hasAttemptedToday
                  ? 'Today\'s Score: ${QuizRepository.lastScore}/10 (${QuizRepository.lastTimeTaken}) • Tap to review'
                  : '10 Questions in 10 Mins • Test your prep today'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showDailyQuizSheet(context, onStateChange: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: purple),
              title: const Text('Request Seat / Shift Change (सीट व समय अर्जी)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Request desk swap or switch between Full / Half Day'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showSeatChangeRequestSheet(context, onStateChange: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner, color: green),
              title: const Text('Pay / Renew Monthly Fee (ऑनलाइन फीस जमा करें)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Direct UPI transfer to Admin Kamal account'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showFeePaymentSheet(context, onPaymentSuccess: refresh),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: blue),
              title: const Text('My Membership Receipt (रसीद)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Official Krishna Library fee receipt & slip'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showMemberReceiptSheet(context, member: activeMember),
            ),
          ],

          const Divider(height: 24),
          ListTile(
            leading: Icon(admin ? Icons.person_outline : Icons.admin_panel_settings_outlined, color: blue),
            title: Text(
              admin ? 'Switch to Member View (${activeMember.name})' : 'Open Admin Console (${AdminData.adminName})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(admin ? 'Experience student/member view' : 'Manage fees, study PDFs & seats'),
            trailing: const Icon(Icons.chevron_right),
            onTap: switchMode,
          ),
          const ListTile(leading: Icon(Icons.help_outline, color: blue), title: Text('Help & support')),
          ListTile(
            leading: const Icon(Icons.logout, color: red),
            title: const Text('Sign out (लॉगआउट करें)', style: TextStyle(color: red, fontWeight: FontWeight.bold)),
            subtitle: const Text('Return to Login Screen / आईडी बदलें'),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  title: const Row(
                    children: [
                      Icon(Icons.logout, color: red),
                      SizedBox(width: 8),
                      Text('लॉगआउट करें?'),
                    ],
                  ),
                  content: const Text('क्या आप सचमुच इस अकाउंट से लॉगआउट करके लॉगिन पेज पर जाना चाहते हैं?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('रद्द करें'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: red, foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(ctx);
                        onSignOut();
                      },
                      child: const Text('लॉगआउट'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
  }
}

class Admin extends StatelessWidget {
  const Admin({
    super.key,
    required this.jump,
    required this.refresh,
    required this.onSignOut,
  });

  final ValueChanged<int> jump;
  final VoidCallback refresh;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => Page(
        child: [
          const Header('Admin Console', 'Good morning, Chief Administrator Kamal.'),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(22)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'KRISHNA LIBRARY\nOperations Master',
                      style: TextStyle(color: Colors.white, fontSize: 18, height: 1.4, fontWeight: FontWeight.w900),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2B84B).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('ADMIN ID: KL-01', style: TextStyle(color: Color(0xFFF2B84B), fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          tooltip: 'लॉगआउट (Sign Out)',
                          icon: const Icon(Icons.logout_rounded, color: Colors.white70, size: 20),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                title: const Row(
                                  children: [
                                    Icon(Icons.logout, color: red),
                                    SizedBox(width: 8),
                                    Text('Admin Logout?'),
                                  ],
                                ),
                                content: const Text('क्या आप एडमिन कंसोल से लॉगआउट करना चाहते हैं?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: red, foregroundColor: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      onSignOut();
                                    },
                                    child: const Text('लॉगआउट'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Branch 01 • Main Study Hall • Capacity 27 Seats', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF269C70),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.person_add_alt_1_rounded, size: 17),
                        label: const Text(
                          'New Admission (छात्र जोड़ें)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                        ),
                        onPressed: () => showAddStudentDialog(context, onSaved: refresh),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE16D5A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.upload_file_rounded, size: 17),
                        label: const Text(
                          'Add PDF (PDF जोड़ें)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                        ),
                        onPressed: () => showAddStudyMaterialDialog(context, onSaved: refresh),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              InkWell(
                onTap: () => showAddStudyMaterialDialog(context, onSaved: refresh),
                borderRadius: BorderRadius.circular(17),
                child: Metric(
                  value: '${StudyRepository.documents.length}',
                  label: 'Study PDFs (Tap to Add)',
                  icon: Icons.picture_as_pdf,
                  color: red,
                ),
              ),
              InkWell(
                onTap: () => showFeeManagementSheet(context, onStateChange: refresh),
                borderRadius: BorderRadius.circular(17),
                child: Metric(
                  value: '₹${AdminData.totalRevenueCollected}',
                  label: 'Fees Collected (Tap for list)',
                  icon: Icons.verified_user_outlined,
                  color: blue,
                ),
              ),
              InkWell(
                onTap: () => jump(1),
                borderRadius: BorderRadius.circular(17),
                child: Metric(
                  value: '${AdminData.totalOccupied}/27',
                  label: 'Occupied Desks (Tap to allot)',
                  icon: Icons.event_seat,
                  color: purple,
                ),
              ),
              InkWell(
                onTap: () => showFeeManagementSheet(context, onStateChange: refresh),
                borderRadius: BorderRadius.circular(17),
                child: Metric(
                  value: '0${AdminData.pendingCount}',
                  label: 'Pending Fees (₹${AdminData.totalPendingAmount})',
                  icon: Icons.payments_outlined,
                  color: amber,
                ),
              ),
            ],
          ),
          // Financial Health & Net Monthly Profit Card
          Container(
            margin: const EdgeInsets.only(top: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F3D2E), Color(0xFF1B6B4C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: green.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Color(0xFF56F5A3), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Financial Health & Net Profit',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.5),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('ADMIN ONLY', style: TextStyle(color: Color(0xFF56F5A3), fontSize: 9.5, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Fees Inflow', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 2),
                          Text('₹${AdminData.totalRevenueCollected}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Expenses Out', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 2),
                          Text('₹${AdminData.totalExpenses}', style: const TextStyle(color: Color(0xFFFF9E9E), fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Net Profit', style: TextStyle(color: Color(0xFF56F5A3), fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('₹${AdminData.netProfit}', style: const TextStyle(color: Color(0xFF56F5A3), fontSize: 18, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F3D2E),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.analytics_outlined, size: 16),
                    label: const Text('Manage Expenses & View P&L Sheet', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    onPressed: () => showExpenseManagerSheet(context, onStateChange: refresh),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle('Management Operations'),
          AdminItem(
            icon: Icons.swap_horiz,
            title: 'Student Requests (${AdminData.pendingRequestsCount} Pending)',
            detail: 'Review & approve desk change and shift upgrade requests with 1-click',
            onTap: () => showAdminRequestsSheet(context, onStateChange: refresh),
          ),
          AdminItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Library Expenses & Net Profit (खर्च व शुद्ध लाभ)',
            detail: 'Electricity, Wi-Fi, Water & Cleaning bills • Net Profit: ₹${AdminData.netProfit}',
            onTap: () => showExpenseManagerSheet(context, onStateChange: refresh),
          ),
          AdminItem(
            icon: Icons.event_seat,
            title: 'Seat Allotment & Member Details',
            detail: 'Manage all 27 fixed seats & view occupant data',
            onTap: () => jump(1),
          ),
          AdminItem(
            icon: Icons.qr_code_scanner,
            title: 'Online Fees Received (ऑनलाइन पेमेंट इनबॉक्स)',
            detail: '${AdminData.transactions.length} online transfers received directly in Kamal UPI account',
            onTap: () => showFeeManagementSheet(context, onStateChange: refresh),
          ),
          AdminItem(
            icon: Icons.payments_outlined,
            title: 'Fee Management (फीस रिकॉर्ड एवं बकाया)',
            detail: '₹${AdminData.totalRevenueCollected} paid • ₹${AdminData.totalPendingAmount} pending (${AdminData.pendingCount} students)',
            onTap: () => showFeeManagementSheet(context, onStateChange: refresh),
          ),
          AdminItem(
            icon: Icons.chat_bubble_outline,
            title: 'WhatsApp Fee Notice (${AdminData.pendingCount} Overdue)',
            detail: '1-Click WhatsApp payment reminders with UPI link to ${AdminData.pendingCount} students',
            onTap: () => showBatchWhatsAppReminderSheet(context, onSent: refresh),
          ),
          AdminItem(
            icon: Icons.upload_file_rounded,
            title: 'Upload / Add Study Material & PDF (नया नोट्स जोड़ें)',
            detail: '${StudyRepository.documents.length} study PDFs published • Tap to add new notes or Drive link',
            onTap: () => showAddStudyMaterialDialog(context, onSaved: refresh),
          ),
          AdminItem(
            icon: Icons.menu_book,
            title: 'Study Materials & PDFs (स्टडी मटेरियल)',
            detail: '${StudyRepository.documents.length} curated exam modules & student notes published',
            onTap: () => jump(2),
          ),
          AdminItem(
            icon: Icons.badge_outlined,
            title: 'Student ID Cards & Passes (पहचान पत्र)',
            detail: 'Generate & inspect digital student gate passes with barcode & Kamal seal',
            onTap: () => showStudentIdCardSheet(context),
          ),
          AdminItem(
            icon: Icons.quiz_outlined,
            title: 'Daily Exam Quiz & Hall Leaderboard',
            detail: 'Review today\'s 10-min booster test & student ranking standings',
            onTap: () => showDailyQuizSheet(context, onStateChange: refresh),
          ),
          AdminItem(
            icon: Icons.qr_code_scanner,
            title: 'Personal Payment QR / Barcode (पर्सनल QR सेटिंग्स)',
            detail: 'Set custom UPI ID (${AdminData.adminUpiId}), payee name & standee photo',
            onTap: () => showCustomQrSettingsDialog(context, onSaved: refresh),
          ),
          AdminItem(
            icon: Icons.auto_awesome,
            title: 'Krishna AI Study Guru (Gemini Flash ⚡)',
            detail: 'AI doubt solver, exam research & Gemini Flash API configuration',
            onTap: () => showKrishnaAiSearchSheet(context),
          ),
        ],
      );
}

class Page extends StatelessWidget {
  const Page({super.key, required this.child});
  final List<Widget> child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: child),
      );
}

class Brand extends StatelessWidget {
  const Brand({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.auto_stories, color: Color(0xFFF2B84B)),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KRISHNA LIBRARY', style: TextStyle(fontWeight: FontWeight.w900, color: navy)),
                Text('Study Today • Build Tomorrow', style: TextStyle(fontSize: 10, color: Colors.blueGrey)),
              ],
            ),
          ),
          InkWell(
            onTap: () => showKrishnaAiSearchSheet(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: purple.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, size: 13, color: purple),
                  SizedBox(width: 4),
                  Text('AI Guru', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: purple)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.notifications_none, color: navy),
        ],
      );
}

class Header extends StatelessWidget {
  const Header(this.title, this.subtitle, {super.key});
  final String title, subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: navy)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Colors.blueGrey)),
        ],
      );
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 170,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(22)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=1000&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, e, s) => const SizedBox(),
            ),
            Container(color: const Color(0xAA102A43)),
            const Positioned(
              left: 20,
              top: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('A better place to', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 4),
                  Text('focus & grow.', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
                  SizedBox(height: 12),
                  Text('27 seats • 14 Study PDFs (हिन्दी & English)', style: TextStyle(color: Color(0xFFF2B84B), fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );
}

class Stat extends StatelessWidget {
  const Stat(this.name, this.value, this.color, {super.key});
  final String name, value;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.circle, color: color, size: 15),
              const SizedBox(height: 6),
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
              Text(name, style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
            ],
          ),
        ),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {this.action = '', super.key});
  final String text, action;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: navy)),
          if (action.isNotEmpty) Text(action, style: const TextStyle(color: blue, fontSize: 11, fontWeight: FontWeight.w800)),
        ],
      );
}

class ActionItem extends StatelessWidget {
  const ActionItem(this.text, this.icon, this.onTap, {super.key});
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Icon(icon, color: blue),
              ),
              const SizedBox(height: 7),
              Text(text, style: const TextStyle(fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );
}

class CardBox extends StatelessWidget {
  const CardBox({super.key, required this.icon, required this.title, required this.detail});
  final IconData icon;
  final String title, detail;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19)),
        child: Row(
          children: [
            Icon(icon, color: blue, size: 30),
            const SizedBox(width: 13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
                const SizedBox(height: 5),
                Text(detail, style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
              ],
            ),
          ],
        ),
      );
}

class Notice extends StatelessWidget {
  const Notice(this.icon, this.title, this.detail, {this.onTap, super.key});
  final IconData icon;
  final String title, detail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
          child: Row(
            children: [
              Icon(icon, color: blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: navy, fontSize: 13)),
                    const SizedBox(height: 5),
                    Text(detail, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                  ],
                ),
              ),
              if (onTap != null) const Icon(Icons.chevron_right, size: 18, color: blue),
            ],
          ),
        ),
      );
}

class Tip extends StatelessWidget {
  const Tip({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFE9F3FF), borderRadius: BorderRadius.circular(18)),
        child: const Text(
          '27 fixed seats • Tap an available seat to request it.',
          style: TextStyle(color: blue, fontWeight: FontWeight.w600),
        ),
      );
}

class Info extends StatelessWidget {
  const Info({super.key, required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.blueGrey)),
            Text(value, style: const TextStyle(color: navy, fontWeight: FontWeight.w800)),
          ],
        ),
      );
}

class Metric extends StatelessWidget {
  const Metric({super.key, required this.value, required this.label, required this.icon, required this.color});
  final String value, label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const Spacer(),
            Text(value, style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.w900)),
            Text(label, style: const TextStyle(color: Colors.blueGrey, fontSize: 11)),
          ],
        ),
      );
}

class AdminItem extends StatelessWidget {
  const AdminItem({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    this.onTap,
  });

  final IconData icon;
  final String title, detail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
        subtitle: Text(detail),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );
}

void info(BuildContext context, String title, List<String> rows) => showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          ...rows.map((row) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(row))),
        ]),
      ),
    );
