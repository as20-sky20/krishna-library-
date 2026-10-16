import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/ai_search_service.dart';

void main() {
  test('Test query matching for Hindi prompt with emojis and Devanagari', () async {
    final res1 = await AiSearchService.ask('📜 मौलिक अधिकार (Articles 14-32) सरल हिन्दी में समझाओ');
    expect(res1.answer.contains('6 मौलिक अधिकार'), isTrue);
    expect(res1.answer.contains('समानता का अधिकार'), isTrue);
    expect(res1.source.contains('Fallback'), isFalse);

    final res2 = await AiSearchService.ask('🏛️ कृष्णा लाइब्रेरी की फीस व सुविधाएं बताओ');
    expect(res2.answer.contains('कमल जी'), isTrue);
    expect(res2.answer.contains('₹1,000'), isTrue);

    final res3 = await AiSearchService.ask('📅 8-घंटे का आदर्श स्टडी टाइम-टेबल');
    expect(res3.answer.contains('सुबह की शिफ्ट'), isTrue);

    final res4 = await AiSearchService.ask('🧠 पढ़ाई में 100% फोकस कैसे लगाएं?');
    expect(res4.answer.contains('पोमोडोरो तकनीक'), isTrue);

    final res5 = await AiSearchService.ask('🔢 प्रतिशत (Percentage) निकालने की आसान ट्रिक');
    expect(res5.answer.contains('प्रतिशत और भिन्न'), isTrue);

    final res6 = await AiSearchService.ask('भारत के प्रधानमंत्री कौन हैं?');
    expect(res6.answer.contains('नरेंद्र मोदी'), isTrue);

    final res7 = await AiSearchService.ask('ताजमहल किसने बनवाया था?');
    expect(res7.answer.contains('शाहजहाँ'), isTrue);
    expect(res7.answer.contains('मुमताज महल'), isTrue);

    final res8 = await AiSearchService.ask('इलेक्ट्रॉन की खोज किसने की थी?');
    expect(res8.answer.contains('जे.जे. थॉमसन'), isTrue);
  });
}
