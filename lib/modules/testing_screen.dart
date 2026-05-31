import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/remote_database.dart';
// Import your database class path here
// import 'package:your_project/database/prod_remote_database.dart';

class NetworkTestScreen extends StatefulWidget {
  const NetworkTestScreen({super.key});

  @override
  State<NetworkTestScreen> createState() => _NetworkTestScreenState();
}

class _NetworkTestScreenState extends State<NetworkTestScreen> {
  // Instantiating your remote database service
  final RemoteDatabase _remoteDatabase = LocalhostRemoteDatabase();

  bool _isLoading = false;
  String _statusMessage = "Status: Idle. Press the button to initiate request.";
  String _jsonOutput = "{}";
  Color _statusColor = Colors.grey;

  Future<void> _runNetworkTest() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Sending request to API endpoint...";
      _statusColor = Colors.blue;
      _jsonOutput = "{}";
    });

    try {
      // Trigger your network function
      Map<String, Object?>? response = await _remoteDatabase.getUser("MrBq1EAfvoYAswZZfJrbGSM2jlj1");
      // For test screen feedback integration, we simulate success state feedback.
      // In production, your testConnection() function could return the Map/String directly.
      setState(() {
        _statusMessage = "HTTP SUCCESS: Payload received! Check debug terminal.";
        _jsonOutput = response.toString();
        _statusColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _statusMessage = "CRITICAL FAILURE: Look at debug terminal for full stacktrace.";
        _jsonOutput = '{\n  "error": "${e.toString()}"\n}';
        _statusColor = Colors.red;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Connectivity Endpoint Test"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0), // Generous padding for tablet viewports
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600), // Keeps layout neat on large tablet screens
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Connection Status Card Container
                Card(
                  elevation: 4,
                  color: _statusColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: _statusColor, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _statusColor == Colors.grey ? Colors.black87 : _statusColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 2. Terminal Console Display Mockup
                const Text(
                  "UI Parsed Console Output:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _jsonOutput,
                        style: const TextStyle(
                          fontFamily: 'Courier', // Monospace styling for code block view
                          color: Colors.greenAccent,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 3. Execution Trigger Button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _runNetworkTest,
                  icon: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Icon(Icons.network_ping),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      _isLoading ? "Communicating..." : "Ping API Server",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}