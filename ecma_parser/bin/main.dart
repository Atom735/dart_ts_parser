import 'dart:io';

import 'package:ecma_parser/ecma_parser.dart' as ecma_parser;
import 'package:ecma_parser/parsers.dart';
import 'package:ecma_parser/tokens.dart';
import 'package:ecma_parser/rules.dart';
import 'package:source_span/source_span.dart';

void main(List<String> arguments) {
  final path = r'datas/colorRegistry.ts';
  final text = File(path).readAsStringSync();
  for (var item
      in Tokenizer().tokinize(SourceFile.fromString(text, url: path))) {
    print(item);
  }
}
