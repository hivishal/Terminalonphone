import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'dart:io';
import 'dart:convert';
import 'terminal_widgets.dart';
import 'ssh_manager.dart';


void main() => runApp(const SSHTerminalApp());

class SSHTerminalApp extends StatelessWidget {
  const SSHTerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSH Terminal',
      home: TerminalPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TerminalPage extends StatefulWidget {
  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  final TextEditingController _cmdCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _hostCtrl = TextEditingController(text: 'XXX.XXX.XXX.XX');
  final TextEditingController _portCtrl = TextEditingController(text: 'XXXX');
  final TextEditingController _userCtrl = TextEditingController(text: 'root');
  final TextEditingController _passCtrl = TextEditingController();

  late SSHClient _client;
  SSHSession? _session;
  String _output = '';
  bool _connected = false;
  bool _usePassword = true;

  Future<void> _connectSSH() async {
    setState(() {
      _output = 'Connecting to ${_hostCtrl.text}:${_portCtrl.text} as ${_userCtrl.text}...\n';
    });

    try {
      final client = await SSHManager.connect(
        host: _hostCtrl.text,
        port: int.parse(_portCtrl.text),
        username: _userCtrl.text,
        password: _usePassword ? _passCtrl.text : null,
      );
      _client = client;

      _session = await _client.execute("bash");
      setState(() {
        _connected = true;
        _output += 'Connected!\n';
      });

      _session!.stdout.cast<List<int>>().transform(utf8.decoder).listen((data) {
        setState(() {
          _output += data;
        });
        _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
      });
    } catch (e) {
      setState(() {
        _output += 'Error: $e\n';
      });
    }
  }

  void _sendCommand() {
    final cmd = _cmdCtrl.text.trim();
    if (cmd.isNotEmpty && _session != null) {
      setState(() {
        final prompt = SSHManager.generatePrompt(_userCtrl.text, _hostCtrl.text);
        _output += '\n$prompt $cmd\n\n';
      });
      _session!.write(utf8.encode('$cmd\n'));
      _cmdCtrl.clear();
    }
  }




  Future<void> _downloadFile() async {
    try {
      final remotePath = await showInputDialog(context, 'Enter file path to download:');
      if (remotePath != null) {
        final localPath = await SSHManager.downloadFile(_client, remotePath);
        setState(() {
          _output += 'Downloaded to $localPath\n';
        });
      }
    } catch (e) {
      setState(() {
        _output += 'Download error: $e\n';
      });
    }
  }

  Future<void> _uploadFile() async {
    try {
      final uploadedPath = await SSHManager.uploadFile(_client);
      setState(() {
        _output += 'Uploaded to $uploadedPath\n';
      });
    } catch (e) {
      setState(() {
        _output += 'Upload error: $e\n';
      });
    }
  }

  @override
  void dispose() {
    _session?.close();
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildTerminalUI(
      context,
      connected: _connected,
      scrollCtrl: _scrollCtrl,
      output: _output,
      hostCtrl: _hostCtrl,
      portCtrl: _portCtrl,
      userCtrl: _userCtrl,
      passCtrl: _passCtrl,
      usePassword: _usePassword,
      onAuthToggle: (val) => setState(() => _usePassword = val),
      onConnect: _connectSSH,
      onDownload: _downloadFile,
      onUpload: _uploadFile,
      cmdCtrl: _cmdCtrl,
      onSend: _sendCommand,
    );
  }
}
