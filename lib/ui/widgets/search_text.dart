import 'dart:math';

import 'package:flutter/material.dart';

class HighlightedSearchText extends StatelessWidget {
  final String text;
  final List<String> highlights;
  // final String matchText;
  final Color textColor;
  final Color highlightColor;
  final TextStyle style;
  final bool highlight;
  final bool caseSensitive;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final Locale locale;
  final StrutStyle strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior textHeightBehavior;

  HighlightedSearchText({
    Key key,
    this.text,
    this.highlights,
    // this.matchText = "big",
    this.textColor = Colors.black,
    this.highlightColor = Colors.lightBlue,
    this.highlight = true,
    this.caseSensitive = false,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines = 1,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
  }) : super(key: key);

  RichText _richText(TextSpan text) {
    return RichText(
      key: key,
      text: text,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  // TextSpan _highlightSpanBg(String value) {
  //   if (style.color == null) {
  //     return TextSpan(
  //       text: value,
  //       style: style.copyWith(
  //         color: Colors.black,
  //         backgroundColor: highlightColor,
  //       ),
  //     );
  //   } else {
  //     return TextSpan(
  //       text: value,
  //       style: style.copyWith(
  //         backgroundColor: highlightColor,
  //       ),
  //     );
  //   }
  // }

  TextSpan _highlightSpanText(String value) {
    return TextSpan(
      text: value,
      style: style.copyWith(
        color: highlightColor,
      ),
    );
  }

  TextSpan _normalSpan(String value) {
    if (style.color == null) {
      return TextSpan(
        text: value,
        style: style.copyWith(
          color: Colors.black,
        ),
      );
    } else {
      return TextSpan(
        text: value,
        style: style,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (text == '' || highlights.isEmpty) {
      return _richText(TextSpan(text: text, style: style));
    } else {
      for (int i = 0; i < highlights.length; i++) {
        if (highlights[i] == null) {
          assert(highlights[i] != null);
          return _richText(_normalSpan(text));
        }
        if (highlights[i].isEmpty) {
          assert(highlights[i].isNotEmpty);
          return _richText(_normalSpan(text));
        }
      }

      //Main code
      List<TextSpan> _spans = [];
      int _start = 0;

      //For "No Case Sensitive" option
      String _lowerCaseText = text.toLowerCase();
      List<String> _lowerCaseHighlights = [];

      highlights.forEach((element) {
        _lowerCaseHighlights.add(element.toLowerCase());
      });

      while (true) {
        Map<int, String> _highlightsMap =
            Map(); //key (index), value (highlight).

        if (caseSensitive) {
          for (int i = 0; i < highlights.length; i++) {
            int _index = text.indexOf(highlights[i], _start);
            if (_index >= 0) {
              _highlightsMap.putIfAbsent(_index, () => highlights[i]);
            }
          }
        } else {
          for (int i = 0; i < highlights.length; i++) {
            int _index =
                _lowerCaseText.indexOf(_lowerCaseHighlights[i], _start);
            if (_index >= 0) {
              _highlightsMap.putIfAbsent(_index, () => highlights[i]);
            }
          }
        }

        if (_highlightsMap.isNotEmpty) {
          List<int> _indexes = [];
          _highlightsMap.forEach((key, value) => _indexes.add(key));

          int _currentIndex = _indexes.reduce(min);
          String _currentHighlight = text.substring(_currentIndex,
              _currentIndex + _highlightsMap[_currentIndex].length);

          if (_currentIndex == _start) {
            _spans.add(_highlightSpanText(_currentHighlight));
            _start += _currentHighlight.length;
          } else {
            _spans.add(_normalSpan(text.substring(_start, _currentIndex)));
            _spans.add(_highlightSpanText(_currentHighlight));
            _start = _currentIndex + _currentHighlight.length;
          }
        } else {
          _spans.add(_normalSpan(text.substring(_start, text.length)));
          break;
        }
      }

      return _richText(TextSpan(children: _spans));
    }
    //   if (caseSensitive == true) {
    //     return _richText(
    //         TextSpan(text: text, style: style.copyWith(color: highlightColor)));
    //   } else {
    //     List<TextSpan> resultTextSpan = [];
    //     String fullText = text.toLowerCase();
    //     String highlightedText = matchText.toLowerCase();
    //     fullText.splitMapJoin(
    //       highlightedText,
    //       onMatch: (match) {
    //         resultTextSpan.add(_highlightSpanText(highlightedText));
    //         return "";
    //       },
    //     );

    //     print(fullText);
    //     print(highlightedText);
    //     // print(result);
    //     print(resultTextSpan);
    //     return _richText(
    //         TextSpan(text: text, style: style.copyWith(color: highlightColor)));
    //   }

    // }
  }
}
