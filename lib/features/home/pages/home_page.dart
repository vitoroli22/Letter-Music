import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../music/pages/music_search_page.dart';
import '../../history/pages/history_page.dart';
import '../../profile/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0; // 0 = Músicas, 1 = Álbuns

  Future<List<Map<String, dynamic>>> getMusicRanking() async {
    final snapshot = await FirebaseFirestore.instance.collection('reviews').get();
    Map<String, List<Map<String, dynamic>>> musicGroups = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      String title = data['title'] ?? '';
      if (title.isEmpty) continue;

      if (!musicGroups.containsKey(title)) {
        musicGroups[title] = [];
      }
      musicGroups[title]!.add(data);
    }

    List<Map<String, dynamic>> finalRanking = [];

    musicGroups.forEach((title, reviews) {
      double sumRatings = 0;
      for (var r in reviews) {
        sumRatings += (r['rating'] as num? ?? 0).toDouble();
      }

      int totalAvaliacoes = reviews.length;
      double mediaUsuario = sumRatings / totalAvaliacoes;
      double mediaEscala10 = mediaUsuario * 2;
      double pontuacaoRanking;

      if (mediaEscala10 == 10.0 && totalAvaliacoes >= 10) {
        pontuacaoRanking = 10.0;
      } else if (mediaEscala10 == 10.0 && totalAvaliacoes < 3) {
        pontuacaoRanking = mediaEscala10 - 1.5;
      } else if (mediaEscala10 == 10.0 && totalAvaliacoes < 10) {
        pontuacaoRanking = mediaEscala10 - 0.5;
      } else {
        if (totalAvaliacoes >= 15) {
          pontuacaoRanking = mediaEscala10 + 0.2;
        } else if (totalAvaliacoes < 3) {
          pontuacaoRanking = mediaEscala10 - 1.0;
        } else {
          pontuacaoRanking = mediaEscala10;
        }
      }

      if (pontuacaoRanking > 10.0) pontuacaoRanking = 10.0;
      if (pontuacaoRanking < 0.0) pontuacaoRanking = 0.0;

      var firstReview = reviews.first;

      finalRanking.add({
        'title': title,
        'average': pontuacaoRanking,
        'count': totalAvaliacoes,
        'artist': firstReview['artist'] ?? 'Desconhecido',
        'album': firstReview['album'] ?? 'Desconhecido',
        'image': firstReview['imageUrl'] ?? '',
      });
    });

    finalRanking.sort((a, b) => b['average'].compareTo(a['average']));
    return finalRanking.take(10).toList();
  }

  Future<List<Map<String, dynamic>>> getAlbumRanking() async {
    final snapshot = await FirebaseFirestore.instance.collection('reviews').get();
    Map<String, List<Map<String, dynamic>>> albumGroups = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      String albumName = data['album'] ?? '';
      if (albumName.isEmpty) continue;

      if (!albumGroups.containsKey(albumName)) {
        albumGroups[albumName] = [];
      }
      albumGroups[albumName]!.add(data);
    }

    List<Map<String, dynamic>> finalRanking = [];

    albumGroups.forEach((albumName, reviews) {
      double sumRatings = 0;
      for (var r in reviews) {
        sumRatings += (r['rating'] as num? ?? 0).toDouble();
      }

      int totalVotosNoAlbum = reviews.length;
      double mediaNotasAlbum = sumRatings / totalVotosNoAlbum;
      double mediaEscala10 = mediaNotasAlbum * 2;
      double pontuacaoRankingAlbum;

      if (mediaEscala10 == 10.0 && totalVotosNoAlbum >= 30) {
        pontuacaoRankingAlbum = 10.0;
      } else if (mediaEscala10 == 10.0 && totalVotosNoAlbum < 5) {
        pontuacaoRankingAlbum = mediaEscala10 - 1.8;
      } else if (mediaEscala10 == 10.0 && totalVotosNoAlbum < 30) {
        pontuacaoRankingAlbum = mediaEscala10 - 0.6;
      } else {
        if (totalVotosNoAlbum >= 50) {
          pontuacaoRankingAlbum = mediaEscala10 + 0.3;
        } else if (totalVotosNoAlbum < 5) {
          pontuacaoRankingAlbum = mediaEscala10 - 1.2;
        } else {
          pontuacaoRankingAlbum = mediaEscala10;
        }
      }

      if (pontuacaoRankingAlbum > 10.0) pontuacaoRankingAlbum = 10.0;
      if (pontuacaoRankingAlbum < 0.0) pontuacaoRankingAlbum = 0.0;

      var firstReview = reviews.first;

      finalRanking.add({
        'title': albumName,
        'artist': firstReview['artist'] ?? 'Artista Desconhecido',
        'average': pontuacaoRankingAlbum,
        'count': totalVotosNoAlbum,
        'image': firstReview['imageUrl'] ?? '',
      });
    });

    finalRanking.sort((a, b) => b['average'].compareTo(a['average']));
    return finalRanking.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          // LINDO FUNDO GRADIENTE FIEL ÀS IMAGENS image_04d883.png E image_0482e6.png
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF6E2C82), // Roxo superior
                Color(0xFFC983B8), // Tom médio vibrante iluminado
                Color(0xFF541F6F), // Roxo profundo na base
              ],
            ),
          ),
          child: Stack(
            children: [
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // --- CABEÇALHO SUPERIOR ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                height: 38,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFFC75F),
                                  size: 36,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // TEXTO REESTILIZADO COM COR ROXO/ROSA ILUMINADA E SOMBREADO FRACO (image_0482e6.png)
                              Text(
                                'LetterMusic',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  color: const Color(0xFFEAA6FF), // Tom roxo claro/rosa chiclete idêntico
                                  shadows: [
                                    Shadow(
                                      color: Colors.white.withOpacity(0.05),
                                      offset: const Offset(0, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MusicSearchPage()),
                              );
                            },
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 238, 236, 239).withOpacity(0.25),
                                  width: 1.2,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.search, color: Colors.white60, size: 20),
                                  SizedBox(width: 12),
                                  Text(
                                    'Pesquise por música ou artista',
                                    style: TextStyle(color: Colors.white38, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            height: 38,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => selectedTab = 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selectedTab == 0
                                            ? Colors.white.withOpacity(0.15)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Músicas',
                                          style: TextStyle(
                                            color: selectedTab == 0 ? Colors.white : Colors.white60,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => setState(() => selectedTab = 1)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selectedTab == 1
                                            ? Colors.white.withOpacity(0.15)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Álbuns',
                                          style: TextStyle(
                                            color: selectedTab == 1 ? Colors.white : Colors.white60,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          const Center(
                            child: Text(
                              'Ranking Oficial: Top 10',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- LISTAGEM DE RANKINGS ---
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 140),
                        child: Column(
                          children: [
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: selectedTab == 0 ? getMusicRanking() : getAlbumRanking(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 60),
                                      child: CircularProgressIndicator(color: Color(0xFF00E5FF)),
                                    ),
                                  );
                                }

                                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 60),
                                      child: Text(
                                        'Nenhum dado encontrado no ranking.',
                                        style: TextStyle(color: Colors.white60),
                                      ),
                                    ),
                                  );
                                }

                                final rankingList = snapshot.data!;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: rankingList.length,
                                  itemBuilder: (context, index) {
                                    final item = rankingList[index];
                                    final isTop3 = index < 3;

                                    return Container(
                                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          // CARD PRINCIPAL
                                          Container(
                                            height: 96,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1F0D2B).withOpacity(0.75),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: isTop3
                                                    ? const Color(0xFFFFC75F).withOpacity(0.5)
                                                    : Colors.white10,
                                                width: 1.2,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    bottomLeft: Radius.circular(15),
                                                  ),
                                                  child: Image.network(
                                                    item['image'] ?? '',
                                                    width: 96,
                                                    height: 96,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) =>
                                                        Container(
                                                          width: 96,
                                                          height: 96,
                                                          color: Colors.white12,
                                                          child: const Icon(Icons.music_note, color: Colors.white54),
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item['title'] ?? '',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        selectedTab == 0 ? (item['artist'] ?? '') : 'Álbum',
                                                        style: const TextStyle(color: Colors.white60, fontSize: 13),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 16),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.star, color: Color(0xFFFFC75F), size: 16),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        (item['average'] as double).toStringAsFixed(1),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // NÚMERO DO TOP REESTILIZADO (EFEITO GLASSMORPHIC DESFOCADO - image_04e0be.png)
                                          Positioned(
                                            left: -10,
                                            top: -12,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  // O segredo do desfoque de fundo sem exibir a quina do card por trás
                                                  Positioned.fill(
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                                      child: Container(
                                                        color: const Color(0xFF261435).withOpacity(0.4),
                                                      ),
                                                    ),
                                                  ),
                                                  // Borda dourada/cinza fina contornando o número vazado
                                                  Text(
                                                    '${index + 1}',
                                                    style: TextStyle(
                                                      fontSize: 36, // Ajuste fino no tamanho
                                                      fontWeight: FontWeight.w900,
                                                      foreground: Paint()
                                                        ..style = PaintingStyle.stroke
                                                        ..strokeWidth = 1.0 // Borda fina ultra elegante
                                                        ..color = isTop3 
                                                            ? const Color(0xFFFFC75F).withOpacity(0.9) 
                                                            : Colors.white38,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- BARRA INFERIOR FLUTUANTE LEVEMENTE ELEVADA (image_04e443.png) ---
              Positioned(
                left: 0,
                right: 0,
                bottom: 40, // Subiu um pouquinho para não chocar com a navegação do sistema
                child: Center(
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.transparent, 
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF261435).withOpacity(0.2), 
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFCCCCCC).withOpacity(0.4), 
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildBottomItem(icon: Icons.home_rounded, label: 'Home', onTap: () {}),
                              _buildBottomItem(
                                icon: Icons.history_rounded,
                                label: 'Histórico',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HistoryPage()),
                                  );
                                },
                              ),
                              _buildBottomItem(
                                icon: Icons.person_rounded,
                                label: 'Perfil',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 1),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}