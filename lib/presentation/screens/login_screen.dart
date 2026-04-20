import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _showError = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _showError = true);
      return;
    }

    setState(() => _showError = false);
    
    await ref.read(authProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );
    
    final authState = ref.read(authProvider);
    if (authState.errorMessage != null && mounted) {
      setState(() => _showError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE1), // Light beige background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── LOGO KITCHY ──
                const Text(
                  'KITCHY',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Color(0xFF7A613E), // Dark Gold
                    fontFamily: 'Georgia',
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'GESTIÓN Y COSTEO',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF807667),
                  ),
                ),
                const SizedBox(height: 40),

                // ── ALERT BOX ──
                if (_showError)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF5E1E1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.error_outline, color: Color(0xFFC53030), size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Correo o contraseña incorrectos',
                          style: TextStyle(color: Color(0xFFC53030), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                // ── FORMULARIO ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CORREO ELECTRÓNICO',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFF807667)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'correo@ejemplo.com',
                        hintStyle: const TextStyle(color: Color(0xFFA09C96), fontSize: 14),
                        fillColor: const Color(0xFFEBE6D9), // Beige form field
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    const Text(
                      'CONTRASEÑA',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFF807667)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: Color(0xFFA09C96)),
                        fillColor: const Color(0xFFEBE6D9),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF807667),
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authState.status == AuthStatus.loading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC69E57), // Gold button
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: authState.status == AuthStatus.loading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Iniciar Sesión', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {}, // Forgot password action
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Color(0xFF807667), fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                          onPressed: () => context.push('/register'),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: const Text('Crear cuenta', style: TextStyle(color: Color(0xFF2C2623), fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Color(0xFFD5D1C6))),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.lock_outline, size: 12, color: Color(0xFFD5D1C6)),
                        ),
                        const Expanded(child: Divider(color: Color(0xFFD5D1C6))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
