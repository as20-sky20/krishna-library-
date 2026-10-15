import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/ai_search_service.dart';

void main() {
  test('Test query matching for Hindi prompt with emojis and Devanagari', () async {
    final res1 = await AiSearchService.ask('📜 मौलिक अधिकार (Articles 14-32) सरल हिन्दी में समझाओ');
    print('Query 1 Source: ${res1.source}');
    print('Query 1 Sample: ${res1.answer.substring(0, 100)}...');
    expect(res1.answer.contains('6 मौलिक अधिकार'), isTrue);
    expect(res1.answer.contains('समानता का अधिकार'), isTrue);
    expect(res1.source.contains('Fallback'), isFalse);

    final res2 = await AiSearchService.ask('🏛️ कृष्णा लाइब्रेरी की फीस व सुविधाएं बताओ');
    print('Query 2 Sample: ${res2.answer.substring(0, 80)}...');
    expect(res2.answer.contains('कमल जी'), isTrue);
    expect(res2.answer.contains('₹1,000'), isTrue);

    final res3 = await AiSearchService.ask('📅 8-घंटे का आदर्श स्टडी टाइम-टेबल');
    print('Query 3 Sample: ${res3.answer.substring(0, 80)}...');
    expect(res3.answer.contains('सुबह की शिफ्ट'), isTrue);

    final res4 = await AiSearchService.ask('🧠 पढ़ाई में 100% फोकस कैसे लगाएं?');
    expect(res4.answer.contains('पोमोडोरो तकनीक'), isTrue);

    final res5 = await AiSearchService.ask('🔢 प्रतिशत (Percentage) निकालने की आसान ट्रिक');
    expect(res5.answer.contains('प्रतिशत और भिन्न'), isTrue);

    print('ALL 5 TESTS PASSED SUCCESSFULLY!');
  });
}
