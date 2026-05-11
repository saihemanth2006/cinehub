import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../../features/auth/auth_provider.dart';

import '../main_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoggedIn;
  final VoidCallback? onSignUpRequested;

  const LoginScreen({super.key, this.onLoggedIn, this.onSignUpRequested});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierCtl = TextEditingController();
  final TextEditingController _passwordCtl = TextEditingController();

  Future<void> _tryLogin() async {
    final id = _identifierCtl.text.trim();
    final pwd = _passwordCtl.text;
    if (id.isEmpty || pwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter identifier and password')));
      return;
    }

    try {
      await context.read<AuthProvider>().login(id, pwd);
      if (!mounted) return;
      if (widget.onLoggedIn != null) {
        widget.onLoggedIn!.call();
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _openSignup() {
    if (widget.onSignUpRequested != null) {
      widget.onSignUpRequested!.call();
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back)),
              const SizedBox(height: 8),
              const Text('Welcome Back', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Sign in to continue', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              TextField(controller: _identifierCtl, decoration: const InputDecoration(labelText: 'Email / Username / Phone', prefixIcon: Icon(Icons.person))),
              const SizedBox(height: 12),
              TextField(controller: _passwordCtl, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock))),
              const SizedBox(height: 12),
              Row(children: [Checkbox(value: false, onChanged: (_) {}), const Text('Remember me')]),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: isLoading ? null : _tryLogin, child: isLoading ? const CircularProgressIndicator() : const Text('Log In'))),
              const SizedBox(height: 16),
              Center(child: TextButton(onPressed: _openSignup, child: const Text("Don't have an account? Sign Up"))),
            ],
          ),
        ),
      ),
    );
  }
}

// A minimal SignupScreen used by the login flow if no auth folder existed previously.
class SignupScreen extends StatefulWidget {
  final void Function(BuildContext)? onSignedUp;

  const SignupScreen({super.key, this.onSignedUp});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _otp = TextEditingController();

  final ApiClient _apiClient = ApiClient();

  bool _sending = false;
  bool _verifying = false;
  bool _verified = false;

  Future<void> _sendOtp() async {
    final phone = _phone.text.trim();
    if (phone.isEmpty) return;
    setState(() => _sending = true);
    try {
      final resp = await _apiClient.post('/send-otp', data: {'phone': phone});
      if (resp.statusCode == 200) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent')));
      else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send OTP')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _verifyOtp() async {
    final phone = _phone.text.trim();
    final code = _otp.text.trim();
    if (phone.isEmpty || code.isEmpty) return;
    setState(() => _verifying = true);
    try {
      final resp = await _apiClient.post('/verify-otp', data: {'phone': phone, 'otp': code});
      if (resp.statusCode == 200 && resp.data['ok'] == true) {
        setState(() => _verified = true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone verified')));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification failed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _register() async {
    if (!_verified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please verify phone first')));
      return;
    }
    
    try {
      final resp = await _apiClient.post('/register', data: {
        'fullName': _fullName.text.trim(),
        'email': _email.text.trim(),
        'phone': _phone.text.trim(),
        'password': _password.text,
        'otp': _otp.text.trim(),
      });
      
      if (resp.statusCode == 200 && resp.data['ok'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created')));
        
        // try to auto-login so we get a token and user stored
        try {
          await context.read<AuthProvider>().login(_phone.text.trim(), _password.text);
        } catch (_) {}
        
        if (!mounted) return;
        if (widget.onSignedUp != null) {
          widget.onSignedUp!(context);
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
        }
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration failed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextField(controller: _fullName, decoration: const InputDecoration(labelText: 'Full name')),
          const SizedBox(height: 8),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 8),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: ElevatedButton(onPressed: _sending ? null : _sendOtp, child: const Text('Send OTP')))]),
          const SizedBox(height: 8),
          TextField(controller: _otp, decoration: const InputDecoration(labelText: 'OTP')),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: ElevatedButton(onPressed: _verifying ? null : _verifyOtp, child: const Text('Verify')))]),
          const SizedBox(height: 8),
          TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _register, child: const Text('Create Account')),
        ]),
      ),
    );
  }
}
