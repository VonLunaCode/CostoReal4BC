import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../data/api_provider.dart';
import '../auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final api = ref.read(apiProvider);
      final response = await api.apiV1AuthRegisterPost(
        body: UserCreate(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );

      if (mounted) {
        if (response.isSuccessful) {
          setState(() => _errorMessage = null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Registro exitoso! Iniciando sesión...'), backgroundColor: Color(0xFF6A9B7A)),
          );
          // Auto login tras registro exitoso
          await ref.read(authProvider.notifier).login(_emailController.text, _passwordController.text);
        } else {
          setState(() => _errorMessage = 'Error en registro. El correo podría ya existir.');
        }
      }
      if (mounted) setState(() => _isLoading = false);
    } else {
      setState(() => _errorMessage = 'Por favor, revisa los campos en rojo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD2C5B4).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2C2623).withOpacity(0.06),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Column(
                    children: [
                      const Text(
                        'KITCHY',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF795918),
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'GESTIÓN Y COSTEO',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 2,
                          color: const Color(0xFF4E4639).withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Feedback Banner
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB5656B).withOpacity(0.05),
                        border: Border.all(color: const Color(0xFFB5656B).withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Color(0xFFB5656B), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFFB5656B),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Email
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'CORREO ELECTRÓNICO',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6D605A),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Color(0xFF2C2623)),
                    decoration: InputDecoration(
                      hintText: 'ejemplo@correo.com',
                      hintStyle: TextStyle(color: const Color(0xFF4E4639).withOpacity(0.4)),
                      filled: true,
                      fillColor: const Color(0xFFEAE8E1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Por favor ingresa un email';
                      if (!v.contains('@')) return 'Email no válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'CONTRASEÑA',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6D605A),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Color(0xFF2C2623)),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(color: const Color(0xFF4E4639).withOpacity(0.4)),
                      filled: true,
                      fillColor: const Color(0xFFEAE8E1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: const Color(0xFF4E4639).withOpacity(0.6),
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'REPETIR CONTRASEÑA',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6D605A),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    style: const TextStyle(color: Color(0xFF2C2623)),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(color: const Color(0xFF4E4639).withOpacity(0.4)),
                      filled: true,
                      fillColor: const Color(0xFFEAE8E1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: const Color(0xFF4E4639).withOpacity(0.6),
                        ),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    validator: (v) => (v != _passwordController.text) ? 'Las contraseñas no coinciden' : null,
                  ),
                  
                  const SizedBox(height: 32),

                  // Add Account Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A9B7A), // tertiary-container color
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Crear Cuenta', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Login redirect
                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF795918)), // primary color
                      child: const Text('¿Ya tienes cuenta? Iniciar Sesión'),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bottom decorator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 32, height: 1, color: const Color(0xFFD2C5B4).withOpacity(0.5)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.bakery_dining, color: Color(0xFFD2C5B4), size: 16),
                      ),
                      Container(width: 32, height: 1, color: const Color(0xFFD2C5B4).withOpacity(0.5)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
