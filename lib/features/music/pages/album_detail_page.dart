import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../../home/pages/home_page.dart';
import '../../history/pages/history_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../../../services/spotify_service.dart';
import '../../music/pages/music_detail_page.dart';

class AlbumDetailPage extends StatefulWidget {
  final String albumId;
  final String title;
  final String artist;
  final String imageUrl;

  const AlbumDetailPage({
    super.key,
    required this.albumId,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  final SpotifyService _spotifyService = SpotifyService();
  List<Map<String, dynamic>> _tracks = [];
  bool _isLoading = true;
  double generalRating = 0.0; 

  @override
  void initState() {
    super.initState();
    _loadAlbumTracks();
    _calculateAlbumRating(); 
  }

  Future<void> _calculateAlbumRating() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('album', isEqualTo: widget.title)
          .get();

      if (snapshot.docs.isNotEmpty) {
        double sumRatings = 0;
        for (var doc in snapshot.docs) {
          sumRatings += (doc.data()['rating'] as num? ?? 0).toDouble();
        }

        int totalVotosNoAlbum = snapshot.docs.length;
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

        setState(() {
          generalRating = pontuacaoRankingAlbum;
        });
      }
    } catch (e) {
      debugPrint("Erro ao calcular média do álbum: $e");
    }
  }

  Future<void> _toggleFavorite(Map<String, dynamic> track) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  
    final musicData = {
      'title': track['title'] ?? '',
      'artist': widget.artist,
      'album': widget.title,
      'imageUrl': widget.imageUrl,
    };

    final docSnapshot = await userDoc.get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      final List favorites = data['favorites'] ?? [];
    
      bool isAlreadyFavorite = favorites.any((m) => m['title'] == track['title']);

      if (isAlreadyFavorite) {
        await userDoc.update({
          'favorites': FieldValue.arrayRemove([musicData])
        });
      } else {
        await userDoc.update({
          'favorites': FieldValue.arrayUnion([musicData])
        });
      }
      setState(() {}); 
    }
  }

  Future<void> _loadAlbumTracks() async {
    try {
      if (widget.albumId.isNotEmpty) {
        final tracksList = await _spotifyService.getAlbumTracks(widget.albumId);
        setState(() {
          _tracks = tracksList;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void openHome() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
  void openHistory() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
  void openProfile() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));

  Widget _buildBottomItem({required IconData icon, required String label, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 27),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A101D),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          color: const Color(0xFF1A101D),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF5A1F6F),
                              Color(0xFFC06BB3),
                              Color(0xFF1A101D),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.imageUrl,
                                fit: BoxFit.cover,
                                width: 220,
                                height: 220,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.album, color: Colors.white30, size: 100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 5, child: Container(color: const Color(0xFF1A101D))),
                  ],
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 26),
                            ),
                            const SizedBox(height: 230),
                            Text(
                              widget.title,
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  widget.artist,
                                  style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.bar_chart, color: Colors.white70, size: 16),
                                const SizedBox(width: 4),
                                RichText(
                                  text: TextSpan(
                                    text: 'Avaliação Geral: ',
                                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                                    children: [
                                      TextSpan(
                                        text: generalRating.toStringAsFixed(1),
                                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (_isLoading)
                              const Center(child: CircularProgressIndicator(color: Colors.white))
                            else if (_tracks.isEmpty)
                              const Center(
                                child: Text(
                                  'Nenhuma faixa encontrada para este álbum.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _tracks.length,
                                itemBuilder: (context, index) {
                                  final track = _tracks[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MusicDetailPage(
                                            title: track['title'] ?? '',
                                            subtitle: '${widget.artist} · ${widget.title}',
                                            imageUrl: widget.imageUrl,
                                          ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A1B30),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              widget.imageUrl,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                color: Colors.white12,
                                                width: 50,
                                                height: 50,
                                                child: const Icon(Icons.music_note, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  track['title'] ?? '',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  widget.artist,
                                                  style: const TextStyle(
                                                    color: Colors.white60,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              bool isFav = false;
                                              if (snapshot.hasData && snapshot.data!.exists) {
                                                final data = snapshot.data!.data() as Map<String, dynamic>;
                                                final List favorites = data['favorites'] ?? [];
                                                isFav = favorites.any((m) => m['title'] == track['title']);
                                              }
                                              return IconButton(
                                                icon: Icon(
                                                  isFav ? Icons.favorite : Icons.favorite_border,
                                                  color: isFav ? Colors.redAccent : Colors.white60,
                                                  size: 22,
                                                ),
                                                onPressed: () => _toggleFavorite(track),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(height: 90),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 32, right: 32, bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 9),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6E3D8E).withOpacity(0.92),
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 5))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBottomItem(icon: Icons.home, label: 'Home', onTap: openHome),
                          _buildBottomItem(icon: Icons.history, label: 'Histórico', onTap: openHistory),
                          _buildBottomItem(icon: Icons.person, label: 'Perfil', onTap: openProfile),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}