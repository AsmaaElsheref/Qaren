import 'dart:io';

void main() {
  const oldImport =
      "import 'package:easy_localization/easy_localization.dart';";
  const newImport =
      "import 'package:qaren/core/localization/easy_localization.dart';";
  var count = 0;

  for (final entity in Directory('lib').listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;

    final text = entity.readAsStringSync();
    if (text.contains(oldImport)) {
      entity.writeAsStringSync(text.replaceAll(oldImport, newImport));
      count++;
      stdout.writeln(entity.path);
    }
  }

  stdout.writeln('Updated $count files');
}
