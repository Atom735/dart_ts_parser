abstract class Rules {
  /// U+0009	CHARACTER TABULATION	<TAB>
  static const TAB = '\\u0009';
  static const TAB_ = '\u0009';

  /// U+000B	LINE TABULATION	<VT>
  static const VT = '\\u000B';
  static const VT_ = '\u000B';

  /// U+000C	FORM FEED (FF)	<FF>
  static const FF = '\\u000C';
  static const FF_ = '\u000C';

  /// U+0020	SPACE	<SP>
  static const SP = '\\u0020';
  static const SP_ = '\u0020';

  /// U+00A0	NO-BREAK SPACE	<NBSP>
  static const NBSP = '\\u00A0';
  static const NBSP_ = '\u00A0';

  /// U+FEFF	ZERO WIDTH NO-BREAK SPACE	<ZWNBSP>
  static const ZWNBSP = '\\uFEFF';
  static const ZWNBSP_ = '\uFEFF';

  /// U+000A	LINE FEED (LF)	<LF>
  static const LF = '\\u000A';
  static const LF_ = '\u000A';

  /// U+000D	CARRIAGE RETURN (CR)	<CR>
  static const CR = '\\u000D';
  static const CR_ = '\u000D';

  /// U+2028	LINE SEPARATOR	<LS>
  static const LS = '\\u2028';
  static const LS_ = '\u2028';

  /// U+2029	PARAGRAPH SEPARATOR	<PS>
  static const PS = '\\u2029';
  static const PS_ = '\u2029';

  /// U+200C	ZERO WIDTH NON-JOINER	<ZWNJ>
  static const ZWNJ = '\\u200C';
  static const ZWNJ_ = '\u200C';

  /// U+200D	ZERO WIDTH JOINER	<ZWJ>
  static const ZWJ = '\\u200D';
  static const ZWJ_ = '\u200D';

  static const SourceCharacter = '.';

  /// https://262.ecma-international.org/12.0/#sec-white-space
  static const WhiteSpaces = '(?:$TAB|$VT|$FF|$SP|$NBSP|$ZWNBSP|\\s)';

  /// https://262.ecma-international.org/12.0/#sec-line-terminators
  static const LineTerminator = '(?:$LF|$CR|$LS|$PS)';
  static const LineTerminatorSequence = '(?:$LF|$CR(?!$LF)|$LS|$PS|$CR$LF)';

  /// https://262.ecma-international.org/12.0/#sec-comments
  static const Comment = '(?:$MultiLineComment|$SingleLineComment)';

  static const MultiLineComment = '(?:\\/\\*($MultiLineCommentChars*)\\*\\/)';
  static const MultiLineCommentChars = '(?:(?!\\*\\/)$SourceCharacter)';

  static const MultiLineNotForwardSlashOrAsteriskChar =
      '(?:(?![\\/\\*])$SourceCharacter)';

  static const SingleLineComment = '(?:\\/\\/($SingleLineCommentChars)?)';
  static const SingleLineCommentChars = '$SingleLineCommentChar+';
  static const SingleLineCommentChar =
      '(?:(?!$LineTerminator)$SourceCharacter)';

  /// https://262.ecma-international.org/12.0/#sec-names-and-keywords
  static const IdentifierName = '(?:$IdentifierStart$IdentifierPart*)';
  static const IdentifierStart =
      '(?:$UnicodeIDStart|\\\$|_|\\\\$UnicodeEscapeSequence)';

  static const IdentifierPart =
      '(?:$UnicodeIDContinue|\\\$|\\\\$UnicodeEscapeSequence|$ZWNJ|$ZWJ)';

  static const UnicodeIDStart = '(?:(?!\\d)\\w)';
  static const UnicodeIDContinue = '[_\\w]';

  /// https://262.ecma-international.org/12.0/#prod-ReservedWord
  static const ReservedWord =
      '(?:await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|false|finally|for|function|if|import|in|instanceof|new|null|return|super|switch|this|throw|true|try|typeof|var|void|while|with|yield)';

  /// https://262.ecma-international.org/12.0/#sec-punctuators
  static const Punctuator = '(?:$OptionalChainingPunctuator|$OtherPunctuator)';
  static const OptionalChainingPunctuator = '(?:\\?\\.(?!$DecimalDigit))';
  static const OtherPunctuator =
      '(?:\\>\\>\\>\\=|\\>\\>\\>|\\=\\=\\=|\\!\\=\\=|\\&\\&\\=|\\|\\|\\=|\\?\\?\\=|\\*\\*\\=|\\<\\<\\=|\\>\\>\\=|\\.\\.\\.|\\<\\=|\\>\\=|\\=\\=|\\!\\=|\\*\\*|\\+\\+|\\-\\-|\\<\\<|\\>\\>|\\&\\&|\\|\\||\\?\\?|\\+\\=|\\-\\=|\\*\\=|\\%\\=|\\&\\=|\\|\\=|\\^\\=|\\=\\>|\\<|\\>|\\+|\\-|\\*|\\%|\\&|\\||\\^|\\!|\\~|\\?|\\:|\\=|\\{|\\(|\\)|\\[|\\]|\\.|\\;|\\,)';

  static const DivPunctuator = '(?:\\/\\=|\\/)';
  static const RightBracePunctuator = '(?:\\})';

  /// https://262.ecma-international.org/12.0/#sec-ecmascript-language-lexical-grammar-literals
  static const NullLiteral = '(?:null)';

  /// https://262.ecma-international.org/12.0/#sec-boolean-literals
  static const BooleanLiteral = '(?:true|false)';

  /// https://262.ecma-international.org/12.0/#sec-literals-numeric-literals

  static const NumericLiteral =
      '(?:$DecimalLiteral|$DecimalBigIntegerLiteral|$NonDecimalIntegerLiteral$BigIntLiteralSuffix?)';
  static const NumericLiteralSeparator = '_';

  static const DecimalBigIntegerLiteral =
      '(?:(?:0|$NonZeroDigit(?:$DecimalDigits?|$NumericLiteralSeparator$DecimalDigits))$BigIntLiteralSuffix)';

  static const NonDecimalIntegerLiteral =
      '(?:$BinaryIntegerLiteral|$OctalIntegerLiteral|$HexIntegerLiteral)';

  static const BigIntLiteralSuffix = 'n';

  static const DecimalLiteral =
      '(?:(?:$DecimalIntegerLiteral\\.$DecimalDigits?|\\.$DecimalDigits|$DecimalIntegerLiteral)$ExponentPart?)';
  static const DecimalIntegerLiteral =
      '(?:0|$NonZeroDigit(?:$NumericLiteralSeparator?$DecimalDigits)?)';

  static const DecimalDigits =
      '(?:$DecimalDigit+(?:$NumericLiteralSeparator$DecimalDigit+)*)';
  static const DecimalDigit = '[0-9]';
  static const NonZeroDigit = '[1-9]';

  static const ExponentPart = '(?:$ExponentIndicator$SignedInteger)';
  static const ExponentIndicator = '[eE]';

  static const SignedInteger = '(?:[+-]?$DecimalDigits)';

  static const BinaryIntegerLiteral = '(?:0[bB]$BinaryDigits)';
  static const BinaryDigits =
      '(?:$BinaryDigit+(?:$NumericLiteralSeparator$BinaryDigit+)*)';
  static const BinaryDigit = '[01]';

  static const OctalIntegerLiteral = '(?:0[oO]$OctalDigits)';
  static const OctalDigits =
      '(?:$OctalDigit+(?:$NumericLiteralSeparator$OctalDigit+)*)';
  static const OctalDigit = '[0-7]';

  static const HexIntegerLiteral = '(?:0[xX]$HexDigits)';
  static const HexDigits =
      '(?:$HexDigit+(?:$NumericLiteralSeparator$HexDigit+)*)';
  static const HexDigit = '[0-9a-fA-F]';

  /// https://262.ecma-international.org/12.0/#sec-literals-string-literals

  static const StringLiteral =
      '''(?:(?:\\"$DoubleStringCharacters?\\")|(?:\\'$SingleStringCharacters?\\'))''';

  static const DoubleStringCharacters = '(?:$DoubleStringCharacter+)';
  static const SingleStringCharacters = '(?:$SingleStringCharacter+)';

  static const DoubleStringCharacter =
      '(?:(?!\\"|\\\\|$LineTerminator)$SourceCharacter|$LS|$PS|\\\\$EscapeSequence|$LineContinuation)';

  static const SingleStringCharacter =
      '''(?:(?!\\'|\\\\|$LineTerminator)$SourceCharacter|$LS|$PS|\\\\$EscapeSequence|$LineContinuation)''';

  static const LineContinuation = '(?:\\\\$LineTerminatorSequence)';
  static const EscapeSequence =
      '(?:$CharacterEscapeSequence|0(?!$DecimalDigit)|$HexEscapeSequence|$UnicodeEscapeSequence)';

  static const CharacterEscapeSequence =
      '(?:$SingleEscapeCharacter|$NonEscapeCharacter)';

  static const SingleEscapeCharacter = '''[\\'\\"\\\\\\b\\f\\n\\r\\t\\v]''';
  static const NonEscapeCharacter =
      '(?:(?!$EscapeCharacter|$LineTerminator)$SourceCharacter)';

  static const EscapeCharacter = '(?:$SingleEscapeCharacter|$DecimalDigit|x|u)';
  static const HexEscapeSequence = '(?:x$HexDigit{2})';
  static const UnicodeEscapeSequence = '(?:u(?:$Hex4Digits|\\{$CodePoint\\}))';
  static const Hex4Digits = '(?:$HexDigit{4})';

  /// TODO:
  static const CodePoint = HexDigits;
}
