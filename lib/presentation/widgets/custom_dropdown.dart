import 'package:flutter/material.dart';

import '../../core/config/app_colors.dart';

class CustomDropdown extends FormField<String> {
  CustomDropdown({
    super.key,
    required String hintText,
    required List<String> items,
    String? value,
    void Function(String?)? onChanged,
    IconData? icon,
    super.validator,
  }) : super(
          initialValue: value,
          builder: (FormFieldState<String> state) {
            return _CustomDropdownWidget(
              hintText: hintText,
              items: items,
              value: state.value,
              icon: icon,
              onChanged: (selectedValue) {
                state.didChange(selectedValue);
                onChanged?.call(selectedValue);
              },
              errorText: state.errorText,
            );
          },
        );
}

class _CustomDropdownWidget extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final IconData? icon;
  final String? errorText;

  const _CustomDropdownWidget({
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.icon,
    this.errorText,
  });

  @override
  State<_CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<_CustomDropdownWidget> {
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Center(
                        child: Text(
                          item,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onChanged?.call(item);
                      },
                    ),
                    if (index < widget.items.length - 1)
                      const Divider(
                        color: Color(0xFFF2F2F2),
                        thickness: 1,
                        height: 0,
                      ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          readOnly: true,
          onTap: _showBottomSheet,
          decoration: InputDecoration(
            hintText: widget.value ?? widget.hintText,
            hintStyle: TextStyle(
              color: widget.value == null
                  ? const Color(0xFF849C9E)
                  : AppColors.text,
              fontSize: 16,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: Colors.blue)
                : null,
            suffixIcon:
                const Icon(Icons.arrow_drop_down_rounded, color: Colors.blue),
            errorText: widget.errorText, // Show validation error
          ),
        ),
      ],
    );
  }
}
