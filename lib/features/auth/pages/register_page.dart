import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  Uint8List? selectedImageBytes;

  bool obscurePassword = true;
  bool isLoading = false;

  String? usernameError;
  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 400,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      setState(() {
        selectedImageBytes = bytes;
      });
    }
  }

  String get displayedUsername {
    final text = usernameController.text.trim();

    if (text.isEmpty) {
      return '@seu_usuario';
    }

    return '@${text.replaceAll(' ', '_')}';
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final hasMinLength = password.length >= 6;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(
      r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]=+;]',
    ).hasMatch(password);

    return hasMinLength && hasLetter && hasNumber && hasSpecial;
  }

  Future<void> validateAndSubmit() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      usernameError = null;
      emailError = null;
      passwordError = null;

      if (username.isEmpty) {
        usernameError = 'Informe o nome de usuário';
      } else if (username.length < 3) {
        usernameError = 'O nome de usuário deve ter pelo menos 3 caracteres';
      }

      if (email.isEmpty) {
        emailError = 'Informe o email';
      } else if (!isValidEmail(email)) {
        emailError = 'Informe um email válido';
      }

      if (password.isEmpty) {
        passwordError = 'Informe a senha';
      } else if (!isValidPassword(password)) {
        passwordError =
            'A senha deve ter no mínimo\n6 caracteres\n1 letra\n1 número\n1 caractere especial';
      }
    });

    final hasErrors =
        usernameError != null || emailError != null || passwordError != null;

    if (hasErrors) return;

    setState(() {
      isLoading = true;
    });

    try {
      final usernameExists = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameExists.docs.isNotEmpty) {
        setState(() {
          usernameError = 'Esse nome de usuário já está em uso';
          isLoading = false;
        });
        return;
      }

      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = userCredential.user!.uid;

      final String photoBase64 = selectedImageBytes != null
          ? base64Encode(selectedImageBytes!)
          : '';

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'id': uid,
        'username': username,
        'email': email,
        'photoBase64': photoBase64,
        'createdAt': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      if (e.code == 'email-already-in-use') {
        setState(() {
          emailError = 'Esse e-mail já está cadastrado';
        });
      } else if (e.code == 'weak-password') {
        setState(() {
          passwordError = 'Senha muito fraca';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          emailError = 'E-mail inválido';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar: ${e.message}'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro inesperado: $e'),
        ),
      );
    }
  }

  InputDecoration buildInputDecoration({
    required String hintText,
    String? errorText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF5D2A73)),
      errorText: errorText,
      errorStyle: const TextStyle(
        color: Color.fromARGB(255, 255, 251, 251),
        fontSize: 12,
      ),
      filled: true,
      fillColor: const Color(0xFFE8C9D4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider profileImage = selectedImageBytes != null
        ? MemoryImage(selectedImageBytes!)
        : const AssetImage('assets/images/profile_cat.png');

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF2E6E6),
              Color(0xFFD68BC4),
              Color(0xFF7C3A7A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF5D2A73),
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Seu ouvido crítico\nmerece um perfil oficial.\nJunte-se a nós!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5D2A73),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8C9D4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Color(0xFFA61DDB),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: isLoading ? null : pickImageFromGallery,
                              icon: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 138,
                              height: 138,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFB547E5),
                                  width: 3,
                                ),
                                image: DecorationImage(
                                  image: profileImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: -2,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFA61DDB),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed:
                                      isLoading ? null : pickImageFromGallery,
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          displayedUsername,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5D2A73),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
                  TextField(
                    controller: usernameController,
                    enabled: !isLoading,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5D2A73),
                    ),
                    decoration: buildInputDecoration(
                      hintText: 'Nome de usuário',
                      errorText: usernameError,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5D2A73),
                    ),
                    decoration: buildInputDecoration(
                      hintText: 'Email',
                      errorText: emailError,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    enabled: !isLoading,
                    obscureText: obscurePassword,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5D2A73),
                    ),
                    decoration: buildInputDecoration(
                      hintText: 'Senha',
                      errorText: passwordError,
                      suffixIcon: IconButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF5D2A73),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  SizedBox(
                    width: 285,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA61DDB),
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Cadastre-se',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}