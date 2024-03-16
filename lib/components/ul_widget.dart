import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

enum SymbolTypeEnum { Bullet, Numbered, Custom }

/// Add UL to its children
class ULWidget extends StatelessWidget {
  final List<Widget>? children;
  final double padding;
  final double spacing;
  final SymbolTypeEnum symbolType;
  final Color? symbolColor;
  final Color? textColor;
  final EdgeInsets? edgeInsets;
  final Widget? customSymbol;
  final CrossAxisAlignment? symbolCrossAxisAlignment;
  final String? prefixText; // Used when SymbolType is Numbered

  ULWidget({
    this.children,
    this.padding = 8,
    this.spacing = 8,
    this.symbolType = SymbolTypeEnum.Bullet,
    this.symbolColor,
    this.textColor,
    this.customSymbol,
    this.prefixText,
    this.edgeInsets,
    this.symbolCrossAxisAlignment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children.validate().length, (index) {
        return Padding(
          padding: edgeInsets ?? EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              symbolWidget(index).paddingSymmetric(vertical: 2),
              spacing.toInt().width,
              children![index].expand(),
            ],
          ),
        );
      }),
    );
  }

  /// Returns a symbol widget
  Widget symbolWidget(int index) {
    if (customSymbol != null || symbolType == SymbolTypeEnum.Custom) {
      return customSymbol!;
    } else if (symbolType == SymbolTypeEnum.Bullet) {
      return Text(
        '•',
        style: boldTextStyle(
          color: symbolColor ?? textPrimaryColorGlobal,
          //size: 24,
        ),
      );
    } else if (symbolType == SymbolTypeEnum.Numbered) {
      return Text(
        '${prefixText.validate()} ${index + 1}.',
        style: boldTextStyle(
          color: symbolColor ?? textPrimaryColorGlobal,
        ),
      );
    }

    return Offstage();
  }
}
