import 'package:flutter/material.dart';
import 'package:nodyslexia/modules/main_screen.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/utils/usage_time_tracker.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _displayMessage = '';
  bool _submitDisabled = false;

  void _setDisplayMessage (String newMessage) {
    setState(() {
      _displayMessage = newMessage;
    });
  }

  void _setSubmitDisabled (bool disabled) {
    setState(() {
      _submitDisabled = disabled;
    });
  }

  Future<void> _submitLogin() async {
    // In a real app, you would add authentication logic here
    // For now, just navigate to the main screen
    try {
      _setSubmitDisabled(true);
      final currentRepoManager = context.read<RepoManager>();
      await currentRepoManager.signIn(
          email: _usernameController.text,
          password: _passwordController.text
      );
      if (!mounted) return;
      context.read<UsageTimeTracker>().resumeWithUserData(currentRepoManager.currentStudent?.totalTime ?? 0);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      final String msg = e.toString().replaceFirst('Exception: ', '').replaceFirst('Exception', '');
      _setDisplayMessage(msg);
    } finally {
      _setSubmitDisabled(false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // No AppBar here
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Chào mừng đến với Nokodo', // Added a title to login screen
                textAlign: TextAlign.center,
                style: textTheme.titleLarge
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ e-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Text(
                _displayMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                )
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitDisabled ? null : _submitLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: _submitDisabled ? const Text('Đang xử lý...') : const Text('Đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
