import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/music_review.dart';

class MusicDetailPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl; // URL da capa da música

  const MusicDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  State<MusicDetailPage> createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  double userRating = 0.0;
  double generalRating = 0.0;

  final TextEditingController commentController = TextEditingController();
  final List<Map<String, dynamic>> favoriteMusics = [];
  bool isFavorite = false; 

  @override
  void initState() {
    super.initState();
    loadFavorites(); 
    _calculateGeneralRating(); 
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  // Busca dinamicamente todas as reviews da música e aplica a lógica de pontuação real
  Future<void> _calculateGeneralRating() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('title', isEqualTo: widget.title)
          .get();

      if (snapshot.docs.isNotEmpty) {
        double sumRatings = 0;
        for (var doc in snapshot.docs) {
          sumRatings += (doc.data()['rating'] as num? ?? 0).toDouble();
        }

        int totalAvaliacoes = snapshot.docs.length; 
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

        setState(() {
          generalRating = pontuacaoRanking;
        });
      } else {
        setState(() {
          generalRating = 0.0;
        });
      }
    } catch (e) {
      debugPrint("Erro ao calcular média da música: $e");
    }
  }

  Future<void> loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = snapshot.data();
      setState(() {
        favoriteMusics.clear();
        favoriteMusics.addAll(List<Map<String, dynamic>>.from(data?['favorites'] ?? []));
        isFavorite = favoriteMusics.any((m) => m['title'] == widget.title);
      });
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> music) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final Map<String, dynamic> standardizedMusic = {
      'title': music['title'] ?? '',
      'artist': music['artist'] ?? '',
      'album': music['album'] ?? '',
      'imageUrl': music['imageUrl'] ?? music['image'] ?? '',
    };

    setState(() {
      final int index = favoriteMusics.indexWhere((m) => m['title'] == standardizedMusic['title']);

      if (index != -1) {
        final Map<String, dynamic> musicToRemove = favoriteMusics[index];
        favoriteMusics.removeAt(index);
        userDoc.update({
          'favorites': FieldValue.arrayRemove([musicToRemove])
        });
        isFavorite = false;
      } else {
        favoriteMusics.add(standardizedMusic);
        userDoc.update({
          'favorites': FieldValue.arrayUnion([standardizedMusic])
        });
        isFavorite = true;
      }
    });
  }

  Future<void> saveReview() async {
    if (userRating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha uma nota antes de confirmar.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não logado.')),
      );
      return;
    }

    final String artist = widget.subtitle.split(' · ').first;
    final String album = widget.subtitle.split(' · ').last;

    final String reviewDocId = '${user.uid}_${widget.title}';

    String? currentUsername;
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        currentUsername = userDoc.data()?['username'];
      }
    } catch (e) {
      debugPrint("Erro ao buscar dados do usuário: $e");
    }

    final MusicReview review = MusicReview(
      id: reviewDocId,
      userId: user.uid,
      title: widget.title,
      artist: artist,
      album: album,
      imageUrl: widget.imageUrl,
      rating: userRating,
      comment: commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      final reviewRef = FirebaseFirestore.instance.collection('reviews').doc(reviewDocId);
      final oldReviewDoc = await reviewRef.get();
      
      double oldRating = 0.0;
      bool isEditing = false;

      if (oldReviewDoc.exists) {
        isEditing = true;
        oldRating = (oldReviewDoc.data()?['rating'] as num?)?.toDouble() ?? 0.0;
      }

      final Map<String, dynamic> reviewMap = review.toMap();
      
      // AJUSTE: Mantém compatibilidade salvando como ISO-String da data atual
      reviewMap['created_at'] = DateTime.now().toIso8601String(); 
      if (currentUsername != null) {
        reviewMap['username'] = currentUsername;
      }

      await reviewRef.set(reviewMap, SetOptions(merge: true));

      final rankingRef = FirebaseFirestore.instance.collection('music_ranking').doc(widget.title);
      final rankingDoc = await rankingRef.get();

      double sumRatings = userRating;
      int count = 1;

      if (rankingDoc.exists) {
        final data = rankingDoc.data()!;
        
        if (isEditing) {
          sumRatings = (data['sumRatings'] as num).toDouble() - oldRating + userRating;
          count = (data['count'] as num).toInt();
        } else {
          sumRatings = (data['sumRatings'] as num).toDouble() + userRating;
          count = (data['count'] as num).toInt() + 1;
        }
      }

      const int phantomVotes = 10;
      const double phantomRating = 5.0; 

      double sumRatingsScale10 = sumRatings * 2;
      double avg = (sumRatingsScale10 + (phantomVotes * phantomRating)) / (count + phantomVotes);
      double finalScore = avg > 10.0 ? 10.0 : avg;

      await rankingRef.set({
        'title': widget.title,
        'artist': artist,
        'album': album,
        'image': widget.imageUrl, 
        'sumRatings': sumRatings,
        'count': count,
        'average': double.parse(finalScore.toStringAsFixed(2)),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing 
              ? 'Avaliação atualizada para: ${userRating.toStringAsFixed(1)} estrelas'
              : 'Avaliação confirmada: ${userRating.toStringAsFixed(1)} estrelas'),
        ),
      );

      setState(() {
        userRating = 0.0;
        commentController.clear();
      });

      _calculateGeneralRating();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar avaliação: $e')),
      );
    }
  }

  Widget _buildRatingStar(int index) {
    final double fullValue = index.toDouble();
    final double halfValue = fullValue - 0.5;

    IconData icon;
    if (userRating >= fullValue) {
      icon = Icons.star;
    } else if (userRating >= halfValue) {
      icon = Icons.star_half;
    } else {
      icon = Icons.star_border;
    }

    return SizedBox(
      width: 42,
      height: 42,
      child: Stack(
        children: [
          Center(child: Icon(icon, color: Colors.amber, size: 36)),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => userRating = halfValue),
                  child: const SizedBox.expand(),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => userRating = fullValue),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralRating() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bar_chart, color: Colors.white, size: 15),
          const SizedBox(width: 4),
          const Text('Avaliação geral:',
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text(generalRating.toStringAsFixed(1),
              style: const TextStyle(color: Color(0xFFFFC75F), fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String artist = widget.subtitle.split(' · ').first;
    final String album = widget.subtitle.split(' · ').last;

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
                              Color(0xFF2A1235),
                              Color(0xFF5A1F6F),
                              Color(0xFF1A101D),
                            ],
                          ),
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 4, child: Container(color: const Color(0xFF1A101D))),
                  ],
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                            ),
                            const SizedBox(height: 260),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.title,
                                          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(artist,
                                          style: const TextStyle(color: Colors.white70, fontSize: 15)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Álbum: $album',
                                                style: const TextStyle(color: Colors.white54, fontSize: 11),
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildGeneralRating(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => toggleFavorite({
                                    'title': widget.title,
                                    'artist': artist,
                                    'album': album,
                                    'imageUrl': widget.imageUrl,
                                  }),
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.red,
                                    size: 42,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 26),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildRatingStar(1),
                                    _buildRatingStar(2),
                                    _buildRatingStar(3),
                                    _buildRatingStar(4),
                                    _buildRatingStar(5),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.35),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(userRating == 0 ? '0.0' : userRating.toStringAsFixed(1),
                                          style: const TextStyle(color: Colors.white, fontSize: 16)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Sua nota para esta música:',
                              style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFFFC75F), width: 1.2),
                                    ),
                                    child: TextField(
                                      controller: commentController,
                                      maxLines: 3,
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                      decoration: const InputDecoration(
                                        hintText: 'Escreva o seu comentário...',
                                        hintStyle: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.all(14),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: saveReview,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 52,
                                    width: 52,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB000D4),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
                                    ),
                                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 28),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Comentários sobre a Música:',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),

                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('reviews')
                                  .where('title', isEqualTo: widget.title)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator(color: Color(0xFFB000D4)));
                                }

                                final docs = snapshot.data!.docs;
                                if (docs.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text('Nenhum comentário ainda.', style: TextStyle(color: Colors.white54)),
                                  );
                                }

                                final sortedDocs = List.from(docs);
                                sortedDocs.sort((a, b) {
                                  final aData = a.data() as Map<String, dynamic>;
                                  final bData = b.data() as Map<String, dynamic>;
                                  
                                  dynamic aTime = aData['created_at'];
                                  dynamic bTime = bData['created_at'];
                                  if (aTime == null || bTime == null) return 0;
                                  return bTime.toString().compareTo(aTime.toString());
                                });

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: sortedDocs.length,
                                  itemBuilder: (context, index) {
                                    final data = sortedDocs[index].data() as Map<String, dynamic>;
                                    final commentText = data['comment'] ?? '';
                                    final ratingValue = (data['rating'] as num? ?? 0.0).toDouble();
                                    
                                    final String? username = data['username'];
                                    final String? userId = data['userId'];
                                    final String author = username ?? (userId != null && userId.length > 6 ? userId.substring(0, 6) : 'usuario');

                                    // AJUSTE: Converte com segurança de String ISO ou de Timestamp para DD/MM/AAAA
                                    String formattedDate = '';
                                    final dynamic rawDate = data['created_at'];
                                    if (rawDate != null) {
                                      try {
                                        if (rawDate is Timestamp) {
                                          final DateTime dateTime = rawDate.toDate();
                                          formattedDate = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
                                        } else if (rawDate is String) {
                                          final DateTime dateTime = DateTime.parse(rawDate);
                                          formattedDate = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
                                        }
                                      } catch (e) {
                                        debugPrint("Erro ao formatar data: $e");
                                      }
                                    }
                                    
                                    if (commentText.toString().trim().isEmpty) return const SizedBox.shrink();

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.white10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '@$author', 
                                                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                                  ),
                                                  if (formattedDate.isNotEmpty) ...[
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      formattedDate, 
                                                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                                  const SizedBox(width: 4),
                                                  Text(ratingValue.toStringAsFixed(1),
                                                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(commentText, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
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