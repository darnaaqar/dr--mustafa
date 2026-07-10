import 'package:flutter/material.dart';
import '../constants.dart';

class GalleryScreen extends StatelessWidget {
  final bool isArabic;

  const GalleryScreen({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> galleryItems = [
      {'title_ar': 'نتائج التقويم الشفاف', 'title_en': 'Invisalign Results', 'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIgQybrBw0jdVNJ2TtHXLMeA1YXxaCPaqfDfnXZAOl2WDW6IHxebg5on9BOOjfcY6P5Qb8ERySp-p25DLvdBhmgknzTaqhvBtjlR2_0_CMie_SuHBQhYHflTV4sNaPnUVVrnmPvOgeO6BXkTrpKw9PYEVyQ1CO3wqKfdqZZnR5bqUOgXT2W6MVqxJMtRAGVGFNwh-497AHrUdc35ALEDADbCDPw8XO_ZBhk5gHVI5wJYL1Ob2mjg7OarEQRKNlSzE0AFRuHi0k9uU'},
      {'title_ar': 'زراعة الأسنان الرقمية', 'title_en': 'Digital Implants', 'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA4ykSlN3SWUn5pRlkAaENPXVFJRR5isEAN6Bg1qsIa6_RYXmHCTWyobsZe3cL00ocWx26nN8XepasTrmKebv5QdLUR7LNQXgN8uEJmiBIHXlAriivM6PhxTLd0zYCiCZTTkGDZKFtIBfkakEr_3Q4CkXItBtjtBPO7Tqrd5Q2uZzsmyEjF_Y37NYPJ_YNSufleNThjjAcDyxPBeT6rcDI9vlNNJ9eAcNzxp2k_xLz2pxO-_-Do4bTFAqu-oWEys27Bf-QswboKE2w'},
      {'title_ar': 'ابتسامة هوليوود', 'title_en': 'Hollywood Smile', 'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBqMXz8MAjmjwfJgn0tKIIXduy0LG4tv8QWFn24Vo4sIoX4Jc36Rpg0MXKylJiCk9GKqRcdBBuMKXZH2zWTUAtFgrMpUVMHlcI2MhuecOCU6lENbBIOYIomrNtHFtSPRhV7J3SOklaSTquHCt_JjEMHNZlVX5S4B-wWXlGpuAKQit2CJqYHrzDZpFtTnxcX9lBsa26LKs_XGDPh9cbf4M_MmDjaxIRORLbM7PWwq79KIq_LScfwZ0lTXXxb2yeTCY2jaM2c0D4Y-G0'},
      {'title_ar': 'العيادة والتقنيات', 'title_en': 'Clinic & Tech', 'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDR54vqULR55DeThVM_mapE-KhydWzjigm1qrAr1SJ9jodmDvyrXiC67dcuUvqNuoIBrbuqMl5GVlFUQbtxoOLZOzRT7CQ6EGIeUqZrhtW_t4e8_rHiJC8N9mgduhn5asfCbRvuucxiZZ_Gl-R023ROCgpmeEyq5du_Mc14GPdoflWOCQiZi58Z9_i6N12k7vbgbLDOc7ir9o6XQoPfiWoZ-QKOJi3OhX3K6rVeh_BW_s0WDvKnTrnHdVboDCuo7kCPjwg6oStDByI'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: galleryItems.length,
      itemBuilder: (context, index) {
        final item = galleryItems[index];
        return Container(
          decoration: BoxDecoration(
            color: DentalColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    item['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  isArabic ? item['title_ar']! : item['title_en']!,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
