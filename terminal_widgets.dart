import 'package:flutter/material.dart';

Widget buildTerminalUI(
    BuildContext context, {
      required bool connected,
      required ScrollController scrollCtrl,
      required String output,
      required TextEditingController hostCtrl,
      required TextEditingController portCtrl,
      required TextEditingController userCtrl,
      required TextEditingController passCtrl,
      required bool usePassword,
      required void Function(bool) onAuthToggle,
      required VoidCallback onConnect,
      required VoidCallback onUpload,
      required VoidCallback onDownload,
      required TextEditingController cmdCtrl,
      required VoidCallback onSend,
    }) {
  return Scaffold(
    appBar: AppBar(title: const Text('SSH Terminal')),
    body: Column(
      children: [
        if (!connected)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(controller: hostCtrl, decoration: const InputDecoration(labelText: 'Host')),
                TextField(controller: portCtrl, decoration: const InputDecoration(labelText: 'Port'), keyboardType: TextInputType.number),
                TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'Username')),
                if (usePassword)
                  TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                SwitchListTile(
                  title: const Text('Use Password Authentication'),
                  value: usePassword,
                  onChanged: onAuthToggle,
                ),
                ElevatedButton(onPressed: onConnect, child: const Text('Connect')),
              ],
            ),
          ),
        Expanded(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              controller: scrollCtrl,
              child: Text(
                output,
                style: const TextStyle(fontFamily: 'monospace', color: Colors.greenAccent),
              ),
            ),
          ),
        ),
        if (connected)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cmdCtrl,
                  style: const TextStyle(fontFamily: 'monospace'),
                  decoration: const InputDecoration(hintText: 'Enter command'),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: onSend),
              IconButton(icon: const Icon(Icons.upload_file), onPressed: onUpload),
              IconButton(icon: const Icon(Icons.download), onPressed: onDownload),
            ],
          ),
      ],
    ),
  );
}

Future<String?> showInputDialog(BuildContext context, String label) async {
  String input = '';
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(label),
      content: TextField(
        autofocus: true,
        onChanged: (value) => input = value,
        decoration: const InputDecoration(hintText: 'Path'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, input), child: const Text('OK')),
      ],
    ),
  );
}
