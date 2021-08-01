import 'dart:developer';

import 'package:ecma_parser/rules.dart';
import 'package:source_span/source_span.dart';

class Tokenizer {
  static final reLineTerminatorSequence = _regExp(Rules.LineTerminatorSequence);
  static final reWhiteSpace = _regExp(Rules.WhiteSpaces);
  static final reComment = _regExp(Rules.Comment);
  static final reIdentifierName = _regExp(Rules.IdentifierName);
  static final rePunctuator = _regExp(Rules.Punctuator +
      '|' +
      Rules.DivPunctuator +
      '|' +
      Rules.DivPunctuator +
      '|' +
      Rules.RightBracePunctuator);
  static final reNumericLiteral = _regExp(Rules.NumericLiteral);
  static final reStringLiteral = _regExp(Rules.StringLiteral);

  const Tokenizer();
  Iterable<T_Token> tokinize(SourceFile source) sync* {
    var offset = 0;
    final len = source.length;
    final text = source.getText(offset);

    Match? match;
    while (offset < len) {
      match = reLineTerminatorSequence.matchAsPrefix(text, offset);
      if (match != null) {
        yield T_LineTerminatorSequence(source.span(match.start, match.end));
        offset = match.end;
        continue;
      }
      match = reWhiteSpace.matchAsPrefix(text, offset);
      if (match != null) {
        yield T_WhiteSpace(source.span(match.start, match.end));
        offset = match.end;
        continue;
      }
      match = reComment.matchAsPrefix(text, offset);
      if (match != null) {
        yield T_Comment(source.span(match.start, match.end),
            match.group(1) ?? match.group(2)!);
        offset = match.end;
        continue;
      }
      match = reIdentifierName.matchAsPrefix(text, offset);
      if (match != null) {
        yield T_IdentifierName(
            source.span(match.start, match.end), match.group(0)!);
        offset = match.end;
        continue;
      }
      match = rePunctuator.matchAsPrefix(text, offset);
      if (match != null) {
        yield T_Punctuator(
            source.span(match.start, match.end), match.group(0)!);
        offset = match.end;
        continue;
      }
      match = reNumericLiteral.matchAsPrefix(text, offset);
      if (match != null) {
        yield T_NumericLiteral.parse(
            source.span(match.start, match.end), match.group(0)!);
        offset = match.end;
        continue;
      }
      match = reStringLiteral.matchAsPrefix(text, offset);
      if (match != null) {
        yield T_StringLiteral.parse(
            source.span(match.start, match.end), match.group(0)!);
        offset = match.end;
        continue;
      }
      debugger();
      offset++;
    }
  }

  static RegExp _regExp(String str) =>
      RegExp(str, caseSensitive: true, dotAll: true, multiLine: false);
}

abstract class T_Token {
  final FileSpan span;
  int get start => span.start.offset;
  int get end => span.end.offset;
  String get text => span.text;
  const T_Token(this.span);
  @override
  String toString() => runtimeType.toString().padRight(24).substring(0, 24);
}

abstract class T_CommonToken extends T_Token {
  const T_CommonToken(FileSpan span) : super(span);
}

class T_WhiteSpace extends T_Token {
  const T_WhiteSpace(FileSpan span) : super(span);

  @override
  String toString() =>
      super.toString() +
      '\t' +
      text.replaceAllMapped(
          Tokenizer.reWhiteSpace,
          (e) =>
              const <String, String>{
                Rules.TAB_: '<TAB>',
                Rules.VT_: '<VT>',
                Rules.FF_: '<FF>',
                Rules.SP_: '<SP>',
                Rules.NBSP_: '<NBSP>',
                Rules.ZWNBSP_: '<ZWNBSP>',
              }[e.group(0)!] ??
              e
                  .group(0)!
                  .codeUnits
                  .map((i) => '<' + i.toRadixString(16).padLeft(4, '0') + '>')
                  .join(', '));
}

class T_LineTerminatorSequence extends T_Token {
  const T_LineTerminatorSequence(FileSpan span) : super(span);

  @override
  String toString() =>
      super.toString() +
      '\t' +
      text.replaceAllMapped(
          Tokenizer.reLineTerminatorSequence,
          (e) =>
              const <String, String>{
                Rules.LF_: '<LF>',
                Rules.CR_: '<CR>',
                Rules.LS_: '<LS>',
                Rules.PS_: '<PS>',
                '${Rules.CR}${Rules.LF}': '<CRLF>'
              }[e.group(0)!] ??
              e
                  .group(0)!
                  .codeUnits
                  .map((i) => '<' + i.toRadixString(16).padLeft(4, '0') + '>')
                  .join(', '));
}

class T_Comment extends T_Token {
  final String data;
  const T_Comment(FileSpan span, this.data) : super(span);
  @override
  String toString() =>
      super.toString() +
      '\t' +
      data.split('\n').first.split('\r').first.split('').take(32).join();
}

class T_IdentifierName extends T_CommonToken {
  final String data;
  const T_IdentifierName(FileSpan span, this.data) : super(span);
  @override
  String toString() => super.toString() + '\t' + data;
}

class T_Punctuator extends T_CommonToken {
  final String data;
  const T_Punctuator(FileSpan span, this.data) : super(span);
  @override
  String toString() => super.toString() + '\t' + data;
}

class T_NumericLiteral extends T_CommonToken {
  final num data;
  const T_NumericLiteral(FileSpan span, this.data) : super(span);
  factory T_NumericLiteral.parse(FileSpan span, String str) {
    return T_NumericLiteral(span, num.parse(str));
  }
  @override
  String toString() =>
      super.toString() +
      '\t' +
      data.toString() +
      (data is int
          ? ('0x' + (data as int).toRadixString(16).padLeft(16, '0'))
          : '');
}

class T_StringLiteral extends T_CommonToken {
  final String data;
  const T_StringLiteral(FileSpan span, this.data) : super(span);
  factory T_StringLiteral.parse(FileSpan span, String str) {
    return T_StringLiteral(span, str.substring(1, str.length - 1));
  }
  @override
  String toString() =>
      super.toString() +
      '\t' +
      data.split('\n').first.split('\r').first.split('').take(32).join();
}

class T_Template extends T_CommonToken {
  const T_Template(FileSpan span) : super(span);
}
