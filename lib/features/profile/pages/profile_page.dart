import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../home/pages/home_page.dart';
import '../../history/pages/history_page.dart';
import 'edit_profile_page.dart';
import '../../music/pages/music_detail_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showFavorites = true;
  List<Map<String, dynamic>> favoriteMusics = [];

  void openHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void openHistory(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HistoryPage()),
    );
  }

  void openEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
  }

  void removeFavorite(Map<String, dynamic> music) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    setState(() {
      favoriteMusics.removeWhere((m) => m['title'] == music['title']);
    });

    await userDoc.update({
      'favorites': FieldValue.arrayRemove([music])
    });
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

  Widget _buildFavoriteCard({
    required Map<String, dynamic> music,
    required VoidCallback onFavoriteTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicDetailPage(
              title: music['title'] ?? '',
              subtitle: '${music['artist'] ?? 'Desconhecido'} · ${music['album'] ?? 'Desconhecido'}',
              imageUrl: music['imageUrl'] ?? music['image'] ?? '',
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1F0D2B).withOpacity(0.75),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white10,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                music['imageUrl'] ?? music['image'] ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.white12,
                  width: 50,
                  height: 50,
                  child: const Icon(Icons.music_note, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    music['title'] ?? '',
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
                    '${music['artist'] ?? 'Desconhecido'} · ${music['album'] ?? 'Desconhecido'}',
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 22),
              onPressed: onFavoriteTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String photoBase64) {
    if (photoBase64.isEmpty) {
      return const Icon(Icons.person, color: Colors.white54, size: 74);
    }
    try {
      return ClipOval(
        child: Image.memory(
          base64Decode(photoBase64),
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      return const Icon(Icons.person, color: Colors.white54, size: 74);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não está logado.')),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String username = 'usuário';
        String email = user.email ?? 'email não encontrado';
        String photoBase64 = '';
        favoriteMusics = [];

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          username = data['username'] ?? 'usuário';
          email = data['email'] ?? email;
          photoBase64 = data['photoBase64'] ?? '';
          favoriteMusics = List<Map<String, dynamic>>.from(data['favorites'] ?? []);
        }

        return Scaffold(
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF6E2C82),
                    Color(0xFFC983B8),
                    Color(0xFF541F6F),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // --- CABEÇALHO OFICIAL LETTERMUSIC ---
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
                                  Text(
                                    'LetterMusic',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                      color: const Color(0xFFEAA6FF),
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
                              const SizedBox(height: 22),
                              const Center(
                                child: Text(
                                  'Meu Perfil',
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
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 140),
                            child: Column(
                              children: [
                                // Container de Informações do Perfil com as cores especificadas e borda cintilante
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFF00E5FF).withOpacity(0.25),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color(0xFFEAA6FF).withOpacity(0.5),
                                                width: 2,
                                              ),
                                              color: Colors.white.withOpacity(0.05),
                                            ),
                                            child: _buildProfileImage(photoBase64),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            '@$username',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            email,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: GestureDetector(
                                          onTap: () => openEditProfile(context),
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1F0D2B).withOpacity(0.8),
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white24, width: 1.2),
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),
                                InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    setState(() {
                                      showFavorites = !showFavorites;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 48,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white10,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'Meus Favoritos',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          showFavorites ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                          color: Colors.white70,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (showFavorites)
                                  ...favoriteMusics.map((music) {
                                    return _buildFavoriteCard(
                                      music: music,
                                      onFavoriteTap: () => removeFavorite(music),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- BARRA INFERIOR FLUTUANTE IDÊNTICA À HOME ---
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 40,
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
                                  _buildBottomItem(
                                    icon: Icons.home_rounded,
                                    label: 'Home',
                                    onTap: () => openHome(context),
                                  ),
                                  _buildBottomItem(
                                    icon: Icons.history_rounded,
                                    label: 'Histórico',
                                    onTap: () => openHistory(context),
                                  ),
                                  _buildBottomItem(
                                    icon: Icons.person_rounded,
                                    label: 'Perfil',
                                    onTap: () {},
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
      },
    );
  }
}