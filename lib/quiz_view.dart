import 'dart:async';
import 'package:flutter/material.dart';
import 'quiz_data.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);
const purple = Color(0xFF6D5DD3);

void showDailyQuizSheet(BuildContext context, {VoidCallback? onStateChange}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _DailyQuizModal(onStateChange: onStateChange),
  );
}

class _DailyQuizModal extends StatefulWidget {
  final VoidCallback? onStateChange;
  const _DailyQuizModal({this.onStateChange});

  @override
  State<_DailyQuizModal> createState() => _DailyQuizModalState();
}

enum QuizStage { start, running, result }

class _DailyQuizModalState extends State<_DailyQuizModal> {
  QuizStage stage = QuizStage.start;
  String currentLang = 'Hindi'; // 'Hindi' or 'English'
  int currentQuestionIndex = 0;
  final Map<int, int> selectedAnswers = {}; // questionIndex -> optionIndex

  // Timer
  Timer? timer;
  int remainingSeconds = QuizRepository.durationMinutes * 60;
  int secondsUsed = 0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startQuiz() {
    setState(() {
      stage = QuizStage.running;
      currentQuestionIndex = 0;
      selectedAnswers.clear();
      remainingSeconds = QuizRepository.durationMinutes * 60;
      secondsUsed = 0;
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (remainingSeconds <= 1) {
        t.cancel();
        _submitQuiz();
      } else {
        setState(() {
          remainingSeconds--;
          secondsUsed++;
        });
      }
    });
  }

  void _submitQuiz() {
    timer?.cancel();
    int score = 0;
    for (int i = 0; i < QuizRepository.questions.length; i++) {
      if (selectedAnswers[i] == QuizRepository.questions[i].correctAnswerIndex) {
        score++;
      }
    }

    final m = secondsUsed ~/ 60;
    final s = secondsUsed % 60;
    final timeStr = '${m.toString().padLeft(2, '0')}m ${s.toString().padLeft(2, '0')}s';

    QuizRepository.recordAttempt(score: score, timeTaken: timeStr);
    widget.onStateChange?.call();

    setState(() {
      stage = QuizStage.result;
    });
  }

  String _formatTimer(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.90,
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: purple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.quiz_outlined, color: purple, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Exam Booster Quiz',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: navy),
                      ),
                      Text(
                        '10 Min Practice • GK, Maths, Polity & Vyakaran',
                        style: TextStyle(fontSize: 11.5, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main Stage Body
          Expanded(
            child: stage == QuizStage.start
                ? _buildStartScreen()
                : stage == QuizStage.running
                    ? _buildRunningScreen()
                    : _buildResultScreen(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STAGE 1: QUIZ START & LEADERBOARD PREVIEW
  // ==========================================
  Widget _buildStartScreen() {
    final hasAttempt = QuizRepository.hasAttemptedToday;
    final score = QuizRepository.lastScore ?? 0;
    final time = QuizRepository.lastTimeTaken ?? '00m 00s';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
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
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2B84B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('DAILY TEST #104', style: TextStyle(color: navy, fontSize: 9.5, fontWeight: FontWeight.w900)),
                    ),
                    const Text(QuizRepository.quizDate, style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  QuizRepository.quizTitle,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, height: 1.3),
                ),
                const SizedBox(height: 14),

                // Rule badges
                const Row(
                  children: [
                    _Pill(icon: Icons.help_outline, text: '10 Questions'),
                    SizedBox(width: 8),
                    _Pill(icon: Icons.timer_outlined, text: '10 Minutes'),
                    SizedBox(width: 8),
                    _Pill(icon: Icons.language, text: 'हिन्दी / ENG'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // If user already took the quiz today
          if (hasAttempt) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today\'s Test Attempted!',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: navy),
                        ),
                        Text(
                          'Your Score: $score/10  •  Time: $time',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: green),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Review', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => setState(() => stage = QuizStage.result),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Start Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 24),
              label: Text(
                hasAttempt ? 'Retake Practice Test (दोबारा दें)' : 'Start 10-Min Mock Test (शुरू करें)',
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
              ),
              onPressed: _startQuiz,
            ),
          ),
          const SizedBox(height: 24),

          // Hall Leaderboard Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.emoji_events, color: Color(0xFFD4AF37), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Study Hall Leaderboard (टॉप रैंकर्स)',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: navy),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: const Text('Krishna Library', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Leaderboard List
          ...QuizRepository.leaderboard.map((ranker) {
            final isFirst = ranker.rank == 1;
            final isSecond = ranker.rank == 2;
            final isThird = ranker.rank == 3;
            final isUser = ranker.name.contains('Aarav');

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? purple.withValues(alpha: 0.08) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isUser
                      ? purple.withValues(alpha: 0.5)
                      : isFirst
                          ? const Color(0xFFF2B84B)
                          : const Color(0xFFE2E8F0),
                  width: isUser || isFirst ? 1.6 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Rank badge
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isFirst
                          ? const Color(0xFFF2B84B)
                          : isSecond
                              ? const Color(0xFFC0C0C0)
                              : isThird
                                  ? const Color(0xFFCD7F32)
                                  : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#${ranker.rank}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: (isFirst || isSecond || isThird) ? Colors.white : navy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name & Exam
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              ranker.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isUser ? purple : navy,
                              ),
                            ),
                            if (isUser) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(4)),
                                child: const Text('YOU', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Seat S-${ranker.seatNo.toString().padLeft(2, '0')} • ${ranker.exam}',
                          style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),

                  // Score & Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${ranker.score}/10',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: green),
                      ),
                      Text(
                        ranker.timeTaken,
                        style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==========================================
  // STAGE 2: LIVE TEST RUNNING INTERFACE
  // ==========================================
  Widget _buildRunningScreen() {
    final q = QuizRepository.questions[currentQuestionIndex];
    final totalQ = QuizRepository.questions.length;
    final selectedOpt = selectedAnswers[currentQuestionIndex];
    final isUrgent = remainingSeconds <= 120;

    final questionText = currentLang == 'Hindi' ? q.questionHindi : q.questionEnglish;
    final options = currentLang == 'Hindi' ? q.optionsHindi : q.optionsEnglish;

    return Column(
      children: [
        // Top Status Bar: Progress, Timer & Language Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Question Progress
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      'Q ${currentQuestionIndex + 1}/$totalQ',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    q.subject,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blue),
                  ),
                ],
              ),

              // Timer Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isUrgent ? red.withValues(alpha: 0.15) : navy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isUrgent ? red : Colors.transparent),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, size: 14, color: isUrgent ? red : navy),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimer(remainingSeconds),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: isUrgent ? red : navy,
                      ),
                    ),
                  ],
                ),
              ),

              // Language Switcher
              InkWell(
                onTap: () => setState(() => currentLang = currentLang == 'Hindi' ? 'English' : 'Hindi'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.translate, size: 13, color: navy),
                      const SizedBox(width: 4),
                      Text(
                        currentLang == 'Hindi' ? '🇮🇳 हि' : '🇬🇧 EN',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Linear Progress Bar
        LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / totalQ,
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: const AlwaysStoppedAnimation<Color>(green),
          minHeight: 4,
        ),

        // Question & Options Area
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Text
                Text(
                  'प्र. ${currentQuestionIndex + 1}.  $questionText',
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: navy,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),

                // 4 Options
                ...List.generate(options.length, (optIdx) {
                  final isSelected = selectedOpt == optIdx;
                  final prefix = String.fromCharCode(65 + optIdx); // A, B, C, D

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedAnswers[currentQuestionIndex] = optIdx;
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? blue.withValues(alpha: 0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? blue : const Color(0xFFCBD5E1),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isSelected ? blue : const Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                prefix,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  color: isSelected ? Colors.white : navy,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                options[optIdx],
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected ? blue : const Color(0xFF334155),
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: blue, size: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Bottom Navigation Bar
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Prev'),
                onPressed: currentQuestionIndex > 0
                    ? () => setState(() => currentQuestionIndex--)
                    : null,
              ),

              // Clear Answer
              if (selectedOpt != null)
                TextButton(
                  onPressed: () => setState(() => selectedAnswers.remove(currentQuestionIndex)),
                  child: const Text('Clear', style: TextStyle(color: red, fontSize: 12)),
                ),

              // Next or Submit Button
              if (currentQuestionIndex < totalQ - 1)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Next'),
                  onPressed: () => setState(() => currentQuestionIndex++),
                )
              else
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Submit Test (जमा करें)'),
                  onPressed: _showSubmitConfirmDialog,
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSubmitConfirmDialog() {
    final answered = selectedAnswers.length;
    final total = QuizRepository.questions.length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Practice Test?'),
        content: Text('You have answered $answered out of $total questions. Are you sure you want to finish?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Answering')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              _submitQuiz();
            },
            child: const Text('Submit Now'),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STAGE 3: TEST RESULT & SOLUTION REVIEW
  // ==========================================
  Widget _buildResultScreen() {
    final questions = QuizRepository.questions;
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswerIndex) {
        correctCount++;
      }
    }
    final wrongCount = selectedAnswers.length - correctCount;
    final unattempted = questions.length - selectedAnswers.length;
    final percent = (correctCount / questions.length * 100).toInt();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Score Highlight Card
          Container(
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: percent >= 70
                    ? [const Color(0xFF0F3D2E), const Color(0xFF1B6B4C)]
                    : [const Color(0xFF3B1D11), const Color(0xFF8B3A22)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Big Score Circle
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$correctCount/10',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '$percent%',
                        style: const TextStyle(color: Color(0xFF56F5A3), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Feedback & Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        percent >= 80
                            ? '🎉 Outstanding Performance!'
                            : percent >= 50
                                ? '👍 Good Effort! Keep Revising'
                                : '📚 Need More Revision',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Time Taken: ${QuizRepository.lastTimeTaken ?? "04m 15s"} • Desk S-12',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _MetricMini(label: 'Correct', value: '$correctCount', color: const Color(0xFF56F5A3)),
                          const SizedBox(width: 8),
                          _MetricMini(label: 'Wrong', value: '$wrongCount', color: const Color(0xFFFF9E9E)),
                          const SizedBox(width: 8),
                          _MetricMini(label: 'Skipped', value: '$unattempted', color: Colors.white70),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Two Tabs: Solutions & Leaderboard
          const TabBar(
            labelColor: navy,
            unselectedLabelColor: Colors.blueGrey,
            indicatorColor: navy,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
            tabs: [
              Tab(icon: Icon(Icons.check_circle_outline, size: 18), text: 'Detailed Solutions (हल)'),
              Tab(icon: Icon(Icons.emoji_events_outlined, size: 18), text: 'Hall Leaderboard (रैंकिंग)'),
            ],
          ),

          // Tab View Content
          Expanded(
            child: TabBarView(
              children: [
                // 1. Detailed Solutions Tab
                ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: questions.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 12),
                  itemBuilder: (ctx, idx) {
                    final item = questions[idx];
                    final userAns = selectedAnswers[idx];
                    final isCorrect = userAns == item.correctAnswerIndex;
                    final isSkipped = userAns == null;

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCorrect
                              ? green.withValues(alpha: 0.4)
                              : isSkipped
                                  ? const Color(0xFFE2E8F0)
                                  : red.withValues(alpha: 0.4),
                          width: 1.4,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(item.subject, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: navy)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (isCorrect ? green : (isSkipped ? Colors.blueGrey : red)).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isCorrect ? 'CORRECT (+1)' : (isSkipped ? 'SKIPPED (0)' : 'WRONG (0)'),
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: isCorrect ? green : (isSkipped ? Colors.blueGrey : red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Q${idx + 1}. ${item.questionHindi}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: navy, height: 1.3),
                          ),
                          const SizedBox(height: 8),

                          // Correct vs User Answer
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Correct Answer: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
                                    Expanded(
                                      child: Text(
                                        item.optionsHindi[item.correctAnswerIndex],
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: green),
                                      ),
                                    ),
                                  ],
                                ),
                                if (!isCorrect && !isSkipped) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Text('Your Answer: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
                                      Expanded(
                                        child: Text(
                                          item.optionsHindi[userAns],
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Explanation
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline, size: 14, color: amber),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'व्याख्या: ${item.explanationHindi}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.35),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // 2. Hall Leaderboard Tab
                ListView.builder(
                  padding: const EdgeInsets.all(18),
                  itemCount: QuizRepository.leaderboard.length,
                  itemBuilder: (ctx, i) {
                    final r = QuizRepository.leaderboard[i];
                    final isUser = r.name.contains('Aarav');
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? purple.withValues(alpha: 0.08) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isUser ? purple : const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: i == 0
                                  ? const Color(0xFFF2B84B)
                                  : i == 1
                                      ? const Color(0xFFC0C0C0)
                                      : i == 2
                                          ? const Color(0xFFCD7F32)
                                          : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '#${r.rank}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: i < 3 ? Colors.white : navy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.name, style: TextStyle(fontWeight: FontWeight.w800, color: isUser ? purple : navy)),
                                Text('Seat S-${r.seatNo.toString().padLeft(2, '0')} • ${r.exam}', style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${r.score}/10', style: const TextStyle(fontWeight: FontWeight.w900, color: green, fontSize: 13)),
                              Text(r.timeTaken, style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom Action
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retake Test / Back to Practice'),
                onPressed: () => setState(() => stage = QuizStage.start),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _MetricMini extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MetricMini({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(color: Colors.white70, fontSize: 9.5)),
          Text(value, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
