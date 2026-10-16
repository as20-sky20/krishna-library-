import 'package:flutter/material.dart';
import 'admin_data.dart';
import 'whatsapp_url_helper.dart';

const blue = Color(0xFF1769AA);
const navy = Color(0xFF102A43);
const green = Color(0xFF269C70);
const red = Color(0xFFE16D5A);
const amber = Color(0xFFE6A62C);
const purple = Color(0xFF6D5DD3);
const gold = Color(0xFFD4AF37);

class LoginScreen extends StatefulWidget {
  final void Function({required bool isAdmin, MemberRecord? member}) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController(text: 'KL-0248');
  final TextEditingController _pinController = TextEditingController(text: '1234');
  bool _obscurePin = true;
  String? _errorMessage;
  bool _isLoading = false;

  String _cleanPhone(String p) {
    return p.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^91'), '');
  }

  void _handleLogin() async {
    final input = _idController.text.trim();
    final pin = _pinController.text.trim();

    if (input.isEmpty) {
      setState(() {
        _errorMessage = 'कृपया Member ID या मोबाइल नंबर दर्ज करें!';
      });
      return;
    }

    if (pin.isNotEmpty && pin.length < 4) {
      setState(() {
        _errorMessage = 'कृपया सही 4-अंकों का सिक्योरिटी पिन दर्ज करें!';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate quick auth response
    await Future.delayed(const Duration(milliseconds: 300));

    final cleanInput = input.toLowerCase();
    final phoneInput = _cleanPhone(input);

    // 1. Check if Admin Login
    final adminCleanPhone = _cleanPhone(AdminData.adminPhone);
    if (cleanInput == 'kl-01' ||
        cleanInput == 'admin' ||
        cleanInput == 'kamal' ||
        (phoneInput.isNotEmpty && phoneInput == adminCleanPhone)) {
      setState(() => _isLoading = false);
      widget.onLoginSuccess(isAdmin: true, member: null);
      return;
    }

    // 2. Check if Student / Member Login
    MemberRecord? matchedMember;
    for (final m in AdminData.members) {
      if (m.id.toLowerCase() == cleanInput ||
          m.id.toLowerCase().replaceAll('-', '') == cleanInput) {
        matchedMember = m;
        break;
      }
      final memberCleanPhone = _cleanPhone(m.phone);
      if (phoneInput.isNotEmpty && memberCleanPhone == phoneInput) {
        matchedMember = m;
        break;
      }
    }

    setState(() => _isLoading = false);

    if (matchedMember != null) {
      widget.onLoginSuccess(isAdmin: false, member: matchedMember);
    } else {
      setState(() {
        _errorMessage =
            'ID या मोबाइल नंबर नहीं मिला!\nकृपया अपना रजिस्टर्ड नंबर (जैसे: 9812345678) या Member ID दर्ज करें।';
      });
    }
  }

  void _quickFill(String id, String pin) {
    _idController.text = id;
    _pinController.text = pin;
    _handleLogin();
  }

  @override
  void dispose() {
    _idController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo & Header
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1769AA), Color(0xFF102A43)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: navy.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.account_balance, color: Color(0xFFF2B84B), size: 40),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'KRISHNA LIBRARY',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'डिजिटल स्टूडेंट व एडमिन पोर्टल • हिसार',
                    style: TextStyle(fontSize: 12.5, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),

                  // Main Login Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.login_rounded, color: blue, size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'पोर्टल में प्रवेश करें',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: navy),
                                ),
                                Text(
                                  'Enter Member ID or Mobile Number',
                                  style: TextStyle(fontSize: 10.5, color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Login ID or Phone Number Input
                        const Text(
                          'Member ID या मोबाइल नंबर:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: navy),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _idController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'e.g. KL-0248 या 9416011223',
                            hintStyle: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                            prefixIcon: const Icon(Icons.badge_outlined, color: blue, size: 20),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: blue, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Security PIN / Password
                        const Text(
                          'सुरक्षा पिन (PIN / Password):',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: navy),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _pinController,
                          obscureText: _obscurePin,
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) => _handleLogin(),
                          decoration: InputDecoration(
                            hintText: '4-अंकों का पिन (Default: 1234)',
                            hintStyle: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                            prefixIcon: const Icon(Icons.lock_outline, color: blue, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePin ? Icons.visibility_off : Icons.visibility,
                                color: Colors.blueGrey,
                                size: 18,
                              ),
                              onPressed: () => setState(() => _obscurePin = !_obscurePin),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: blue, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Error Message Display
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: red.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.error_outline, color: red, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: red, fontSize: 11.5, fontWeight: FontWeight.bold, height: 1.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Login Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: navy,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 2,
                            ),
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'लॉगिन करें (Log In)',
                                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_rounded, size: 18),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Demo Accounts Chips
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.touch_app_outlined, size: 16, color: blue),
                            SizedBox(width: 6),
                            Text(
                              'त्वरित टेस्ट लॉगिन (1-Tap Demo Access):',
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: navy),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _quickFill('KL-0248', '1234'),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: blue.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: blue.withValues(alpha: 0.3)),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('👨‍🎓 छात्र लॉगिन', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blue)),
                                      Text('Aarav (KL-0248)', style: TextStyle(fontSize: 9.5, color: Colors.blueGrey)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () => _quickFill('KL-01', '1234'),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2B84B).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFF2B84B).withValues(alpha: 0.4)),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('👑 एडमिन लॉगिन', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: navy)),
                                      Text('Director Kamal (KL-01)', style: TextStyle(fontSize: 9.5, color: Colors.blueGrey)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Help / Admission Notice
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'नया एडमिशन लेना है? ',
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                      InkWell(
                        onTap: () {
                          WhatsAppLauncher.openChat(
                            phone: AdminData.adminPhone,
                            message: 'नमस्ते कमल जी! मुझे कृष्णा लाइब्रेरी में नई सीट / एडमिशन के बारे में जानकारी चाहिए।',
                          );
                        },
                        child: const Text(
                          'डायरेक्टर कमल जी से संपर्क करें',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
