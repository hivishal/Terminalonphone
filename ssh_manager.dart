import 'dart:io';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';

class SSHManager {
  static Future<SSHClient> connect({
    required String host,
    required int port,
    required String username,
    String? password,
  }) async {
    final socket = await SSHSocket.connect(host, port);

    if (password != null) {
      return SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final keyFile = File('${dir.path}/id_rsa');
      final keyString = await keyFile.readAsString();
      final privateKey = SSHKeyPair.fromPem(keyString);

      return SSHClient(
        socket,
        username: username,
        identities: privateKey,
      );
    }
  }

  static Future<String> downloadFile(SSHClient client, String remotePath) async {
    final sftp = await client.sftp();
    final remoteFile = await sftp.open(remotePath, mode: SftpFileOpenMode.read);
    final content = await remoteFile.readBytes();
    final downloadsDir = Directory('/storage/emulated/0/Download');
    final localPath = '${downloadsDir.path}/${remotePath.split('/').last}';
    final file = File(localPath);
    await file.writeAsBytes(content);
    return localPath;
  }

  static Future<String> uploadFile(SSHClient client) async {
    final file = await openFile();
    if (file == null) throw 'No file selected';

    final filePath = file.path;
    final fileName = file.name;
    final localFile = File(filePath);
    final bytes = await localFile.readAsBytes();

    final sftp = await client.sftp();
    final remoteFile = await sftp.open(fileName, mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
    await remoteFile.writeBytes(bytes);
    return fileName;
  }

  static String generatePrompt(String username, String hostname) {
    return '\$username@$hostname';
  }
}
