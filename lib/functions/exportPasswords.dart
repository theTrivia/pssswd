import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path/path.dart';
import 'package:pssswd/functions/app_logger.dart';
import 'package:pssswd/functions/passwordDecrypter.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:protect/protect.dart';

class ExportPasswords {
  static protectExcel(File file, String masterPassword) async {
    var unprotectedBytes = await file.readAsBytes();
    ProtectResponse encryptedResponse =
        await Protect.encryptUint8List(unprotectedBytes, masterPassword);
    var data;
    if (encryptedResponse.isDataValid) {
      print('correct');
      data = encryptedResponse.processedBytes;
    } else {
      print('Excel file used for applying password over it is corrupted');
    }
    var outputPath = 'storage/emulated/0/Download/form_encrypted_file.xlsx';
    await File(outputPath)
      ..create(recursive: true)
      ..writeAsBytes(data);

    return outputPath;
  }

  static _sendMail(Directory directory, String filename) async {
    String _senderUserName = 'bfmvsp@gmail.com';
    String _senderPassword = 'pyvpkhoyzlpvolwc';
    final smtpServer = gmail(_senderUserName, _senderPassword);
    final _localFile = File(join(directory.path + '/' + filename));

    var protectedFileDir = await protectExcel(_localFile, '12345');
    final _protectedFile = File(join(protectedFileDir));

    final message = Message()
      ..from = Address(_senderUserName, 'pssswd')
      ..recipients.add('bfmvsp@gmail.com')
      ..subject = 'Your pssswd export'
      ..text = ''
      ..attachments = [FileAttachment(_protectedFile)];

    await send(message, smtpServer);
    AppLogger.printInfoLog('Attachment sent successfully');
  }

  static exportUserEntries(List entries) async {
    final _secureStorage = FlutterSecureStorage();
    final _psd = PasswordDecrypter();
    PermissionStatus permissionResult =
        await SimplePermissions.requestPermission(
            Permission.WriteExternalStorage);
    if (permissionResult == PermissionStatus.authorized) {
      var i = 2;
      final _masterPassword = await _secureStorage.read(key: 'masterPassword');

      final Workbook workbook = new Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1').setText('Name');
      sheet.getRangeByName('B1').setText('User Name');
      sheet.getRangeByName('C1').setText('Password');
      sheet.getRangeByName('D1').setText('URL');

      for (var entry in entries) {
        final _username = entry['data']['username'];
        final _name = entry['data']['name'];
        final _url = entry['data']['url'];
        final _hashedPassword = entry['data']['password'];
        final _randForKeyToStore = entry['data']['randForKeyToStore'];
        final _randForIV = entry['data']['randForIV'];

        final _decryptedEntryPassword = await _psd.getDecryptedPassword(
            _hashedPassword, _randForKeyToStore, _randForIV, _masterPassword);

        sheet.getRangeByName('A$i').setText(_name);
        sheet.getRangeByName('B$i').setText(_username);
        sheet.getRangeByName('C$i').setText(_decryptedEntryPassword);
        sheet.getRangeByName('D$i').setText(_url);

        i++;
      }

      final List<int> bytes = workbook.saveAsStream();

      Directory directory = Directory('storage/emulated/0/Download');
      new Directory(directory.path + '/').create(recursive: true).then((dir) {
        directory = dir;
        File(join(dir.path + '/pssswd_export.xlsx')).writeAsBytes(bytes);
      });
      await _sendMail(directory, 'pssswd_export.xlsx');
      workbook.dispose();
    }
  }
}
