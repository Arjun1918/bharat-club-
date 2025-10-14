import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organization/common/constant/size_constants.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/color_constants.dart';

class TextInputWidget extends StatelessWidget {
  String placeHolder = '';
  String hintText = '';
  late TextEditingController controller;
  TextInputType? textInputType = TextInputType.text;
  String? errorText = '';
  bool? hidePassword = false;
  bool? showFloatingLabel = true;
  bool? isReadOnly = false;
  String? suffixIconType = '';
  Color? hintTextColor;
  Color? labelTextColor;
  Color? borderColor;
  TextCapitalization? textCapitalization;
  int? maxCharLength=300;
  IconData? prefixIcon;
  IconData? suffixIcon;
  Function? onClick;
  Function? onTextChange;
  int maxLines;
  List<TextInputFormatter>? onFilteringTextInputFormatter=[];

  TextInputWidget({
    super.key,
    this.isReadOnly,
    this.suffixIconType,
    required this.placeHolder,
    required this.hintText,
    required this.controller,
    required this.errorText,
    this.hidePassword,
    this.showFloatingLabel,
    this.textInputType,
    this.borderColor,
    this.hintTextColor,
    this.labelTextColor,
    this.textCapitalization,
    this.maxCharLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onClick,
    this.onTextChange,
    this.onFilteringTextInputFormatter,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (onTextChange != null) {
          onTextChange!(value.toString());
        }
      },
      onTap: () {
        if (onClick != null) {
          onClick!("click");
        }
      },
      readOnly: isReadOnly ?? false,
      enableSuggestions: false,
      autocorrect: false,
      controller: controller,
      keyboardType: textInputType,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      maxLines: maxLines,
      obscureText: hidePassword ?? false,
      inputFormatters: onFilteringTextInputFormatter?? <TextInputFormatter>[],
      // maxLength: maxCharLength,
      style: getTextMedium(
          colors: ColorConstants.cAppColors, size: SizeConstants.s1 * 16),
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        // counterStyle: const TextStyle(
        //   height: 0.0,
        // ),
        // counterText: "",
        floatingLabelBehavior: (showFloatingLabel ?? true)
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never,
        labelText: placeHolder,
        hintText: hintText,
        hintStyle: getTextRegular(
            colors: ColorConstants.cAppColors.shade500,
            size: SizeConstants.s1 * 16),
        errorText: errorText,
        errorStyle:
            getTextRegular(colors: Colors.red, size: SizeConstants.s1 * 12),
        labelStyle: getTextRegular(
            colors: ColorConstants.cAppColors.shade500,
            size: SizeConstants.s1 * 16),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: EdgeInsets.all(0.0),
                child: Icon(
                  prefixIcon,
                  size: SizeConstants.s1 * 22,
                ), // icon is 48px widget.
              ),
        prefixIconColor: ColorConstants.cAppColors.shade400,
        suffixIcon: suffixIcon == null
            ? null
            : GestureDetector(
                onTap: () {
                  if (onClick != null) {
                    onClick!("suffixIcon");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(
                    suffixIcon,
                    size: SizeConstants.s1 * 22,
                  ), // icon is 48px widget.
                ),
              ),
        suffixIconColor: ColorConstants.cAppColors.shade700,
      ),
    );
  }
}
