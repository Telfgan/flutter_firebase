import 'package:flutter/material.dart';

class DynamicInputWidget extends StatelessWidget {
  const DynamicInputWidget(
      {required this.controller,
      required this.obscureText,
      required this.focusNode,
      required this.toggleObscureText,
      required this.prefIcon,
      required this.labelText,
      required this.textInputAction,
      required this.isNonPasswordField,
      this.maxLines,
      this.minLines,
      Key? key})
      : super(key: key);

  final bool isNonPasswordField;
  final TextEditingController controller;
  final VoidCallback? toggleObscureText;
  final bool obscureText;
  final FocusNode focusNode;
  final Icon prefIcon;
  final String labelText;
  final TextInputAction textInputAction;
  final int? maxLines;
  final int? minLines; 




  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        label: Text(labelText),
        prefixIcon: prefIcon,
        suffixIcon: IconButton(
          onPressed: toggleObscureText,
          icon: isNonPasswordField
              ? const Icon(null)
              : obscureText
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
        ),
      ),
      focusNode: focusNode,
      textInputAction: textInputAction,
      obscureText: obscureText,
        maxLines: maxLines ?? 1,
   minLines: minLines ?? 1,
    );
  }
}