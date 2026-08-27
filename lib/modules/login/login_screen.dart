// lib/modules/login/login_screen.dart
import 'package:flutter/material.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/modules/login/login_viewmodel.dart';
import 'package:nodyslexia/modules/main_screen.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/utils/usage_time_tracker.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(
        repoManager: context.read<RepoManager>(),
        textSettings: context.read<NokodoSettings>(),
        usageTimeTracker: context.read<UsageTimeTracker>(),
      ),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatefulWidget {
  const _LoginContent();

  @override
  State<_LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<_LoginContent> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _navigateToMainScreen(LoginViewModel viewModel) {
    if (!mounted) return;
    viewModel.setState(LoginState.idle);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  Future<void> _handleLogin(LoginViewModel viewModel) async {
    final success = await viewModel.submitLogin(
      email: _usernameController.text,
      password: _passwordController.text,
    );
    if (success && mounted) {
      _navigateToMainScreen(viewModel);
    }
  }

  void _handleOfflineLogin(LoginViewModel viewModel) {
    final success = viewModel.loginAsOffline();
    if (success && mounted) {
      _navigateToMainScreen(viewModel);
    }
  }

  Future<void> _handleSaveUrl(LoginViewModel viewModel) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final savedUrl = await viewModel.saveUrl(_urlController.text);
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text("Đã lưu URL $savedUrl")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    if (viewModel.state == LoginState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _navigateToMainScreen(viewModel);
        }
      });
    }

    if (viewModel.isCheckingAutoLogin) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  isKeyboardOpen ? "" : 'Chào mừng đến với Nokodo',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ e-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                  viewModel.displayMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: viewModel.isLoading ? null : () => _handleLogin(viewModel),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: textTheme.displayMedium,
                  ),
                  child: viewModel.isLoading
                      ? const Text('Đang xử lý...')
                      : const Text('Đăng nhập'),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: viewModel.isLoading ? null : () => _handleOfflineLogin(viewModel),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    side: const BorderSide(color: Colors.blue),
                    textStyle: textTheme.displayMedium,
                  ),
                  child: const Text('Sử dụng ngoại tuyến'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'Url',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => _handleSaveUrl(viewModel),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: textTheme.displayMedium,
                  ),
                  child: const Text('Lưu URL'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}