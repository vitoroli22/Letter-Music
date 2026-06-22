import 'package:flutter/material.dart';
import 'music_detail_page.dart';
import 'album_detail_page.dart'; // Importação da nova página de detalhes do álbum
import '../../../../services/spotify_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusicSearchPage extends StatefulWidget {
  const MusicSearchPage({super.key});

  @override
  State<MusicSearchPage> createState() => _MusicSearchPageState();
}

class _MusicSearchPageState extends State<MusicSearchPage> {
  final TextEditingController searchController = TextEditingController();
  final SpotifyService spotifyService = SpotifyService();

  String searchText = '';
  int selectedSearchType = 0; // 0 = Músicas, 1 = Álbuns
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> favoriteMusics = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = snapshot.data();
      setState(() {
        favoriteMusics = List<Map<String, dynamic>>.from(data?['favorites'] ?? []);
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
      'imageUrl': music['image'] ?? music['imageUrl'] ?? '', 
    };

    setState(() {
      final int index = favoriteMusics.indexWhere((m) => m['title'] == standardizedMusic['title']);

      if (index != -1) {
        final Map<String, dynamic> musicToRemove = favoriteMusics[index];
        favoriteMusics.removeAt(index);
        userDoc.update({
          'favorites': FieldValue.arrayRemove([musicToRemove])
        });
      } else {
        favoriteMusics.add(standardizedMusic);
        userDoc.update({
          'favorites': FieldValue.arrayUnion([standardizedMusic])
        });
      }
    });
  }

  Future<void> searchMusic(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      if (selectedSearchType == 0) {
        final results = await spotifyService.searchTracks(query);
        setState(() {
          searchResults = results;
        });
      } else {
        final results = await spotifyService.searchAlbums(query);
        setState(() {
          searchResults = results;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar dados: $e')),
      );
    }
  }

  Widget _buildResultCard({
    required Map<String, dynamic> music,
    VoidCallback? onTap,
  }) {
    final bool isFavorite = favoriteMusics.any((m) => m['title'] == music['title']);
    final bool isAlbumType = selectedSearchType == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10, width: 1.2),
      ),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            music['image'] ?? music['imageUrl'] ?? '',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Icon(isAlbumType ? Icons.album : Icons.music_note, color: Colors.white54),
          ),
        ),
        title: Text(
          music['title'] ?? 'Título desconhecido',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          isAlbumType
              ? 'Álbum · ${music['artist'] ?? 'Artista desconhecido'}'
              : '${music['artist'] ?? 'Artista desconhecido'} · ${music['album'] ?? 'Álbum desconhecido'}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isAlbumType 
            ? const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)
            : IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => toggleFavorite(music),
              ),
      ),
    );
  }

  Widget _buildSearchMessage() {
    if (searchText.isEmpty) {
      return Center(
        child: Text(
          selectedSearchType == 0
              ? 'Digite algo para buscar suas músicas favoritas.'
              : 'Digite algo para buscar os álbuns de seus artistas.',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    } else if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum resultado encontrado.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final item = searchResults[index];
          return _buildResultCard(
            music: item,
            onTap: () {
              if (selectedSearchType == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicDetailPage(
                      title: item['title'] ?? '',
                      subtitle: '${item['artist'] ?? ''} · ${item['album'] ?? ''}',
                      imageUrl: item['image'] ?? item['imageUrl'] ?? '',
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumDetailPage(
                      albumId: item['id'] ?? '',
                      title: item['title'] ?? '',
                      artist: item['artist'] ?? '',
                      imageUrl: item['image'] ?? item['imageUrl'] ?? '',
                    ),
                  ),
                );
              }
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2B124C),
              Color(0xFF19092B),
              Color(0xFF0F051D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabeçalho Oficial: Botão voltar + Logo + Título LetterMusic
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            'assets/images/logo.png',
                            height: 38,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'LetterMusic',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                              color: const Color(0xFFEAA6FF),
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.35),
                                  offset: const Offset(0, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Seletores de aba ("Músicas" e "Álbuns") Centralizados
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSearchType = 0;
                                  searchResults = [];
                                });
                                if (searchText.isNotEmpty) searchMusic(searchText);
                              },
                              child: Text(
                                'Músicas',
                                style: TextStyle(
                                  color: selectedSearchType == 0 ? const Color(0xFFFFC75F) : Colors.white60,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 32),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSearchType = 1;
                                  searchResults = [];
                                });
                                if (searchText.isNotEmpty) searchMusic(searchText);
                              },
                              child: Text(
                                'Álbuns',
                                style: TextStyle(
                                  color: selectedSearchType == 1 ? const Color(0xFFFFC75F) : Colors.white60,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Barra de Pesquisa customizada oficial
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF00E5FF).withOpacity(0.25),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.white70, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: selectedSearchType == 0 
                                      ? 'Músicas, artistas ou álbuns...'
                                      : 'Pesquisar álbuns ou artistas...',
                                  hintStyle: const TextStyle(color: Colors.white60, fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                  searchMusic(searchText);
                                },
                              ),
                            ),
                            if (searchText.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    searchText = '';
                                    searchResults = [];
                                  });
                                },
                                icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildSearchMessage(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}