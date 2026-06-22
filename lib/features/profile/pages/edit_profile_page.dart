import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  File? profileImage;       // imagem selecionada
  String? currentPhotoUrl;  // imagem atual do Firestore

  bool loading = true;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        usernameController.text = data['username'] ?? '';
        currentPhotoUrl = data['photoUrl'];
      }
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadProfileImage(File image) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final ref = _storage.ref().child('profile_images/${user.uid}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar foto de perfil.')),
      );
      return null;
    }
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      String? photoUrl = currentPhotoUrl;

      if (profileImage != null) {
        photoUrl = await _uploadProfileImage(profileImage!);
      }

      await _firestore.collection('users').doc(user.uid).update({
        'username': usernameController.text.trim(),
        'photoUrl': photoUrl,
      });

      if (passwordController.text.isNotEmpty) {
        await user.updatePassword(passwordController.text.trim());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil salvo com sucesso.')),
      );

      Navigator.pop(context, true); // retorna true para atualizar profile
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1D8DF),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF7E5EA),
                Color(0xFFE7A5D2),
                Color(0xFF8C3B77),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF9B30FF),
                          size: 26,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Meu Perfil',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF4C2565),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Container da foto de perfil
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.42),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFB000D4), width: 2),
                                  color: Colors.white.withOpacity(0.25),
                                  image: profileImage != null
                                      ? DecorationImage(
                                          image: FileImage(profileImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : (currentPhotoUrl != null
                                          ? DecorationImage(
                                              image: NetworkImage(currentPhotoUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null),
                                ),
                                child: profileImage == null && currentPhotoUrl == null
                                    ? const Icon(Icons.person, color: Colors.white, size: 74)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              usernameController.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF5A1F6F),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Ícones de edição permanecem
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB000D4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 88,
                          right: 118,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB000D4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  TextField(
                    controller: usernameController,
                    style: const TextStyle(
                      color: Color(0xFF4C2565),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nome de usuário',
                      hintStyle: const TextStyle(color: Color(0xFF7B4A7E)),
                      filled: true,
                      fillColor: const Color(0xFFF2E4E4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(
                      color: Color(0xFF4C2565),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      hintStyle: const TextStyle(color: Color(0xFF7B4A7E)),
                      filled: true,
                      fillColor: const Color(0xFFF2E4E4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                    ),
                  ),

                  const SizedBox(height: 140),

                  SizedBox(
                    width: 285,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB000D4),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}