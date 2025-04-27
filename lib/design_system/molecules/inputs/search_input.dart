import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/shadow.dart';
import '../../atoms/icons.dart'; // <- now correctly used

enum SearchInputMode {
  map,
  list,
}

class SearchInput extends StatefulWidget {
  final SearchInputMode mode;
  final TextEditingController controller;
  final VoidCallback? onTap;

  const SearchInput({
    super.key,
    required this.mode,
    required this.controller,
    this.onTap,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  bool _isFocused = false;

  void _clearInput() {
    widget.controller.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {}); // Listen to text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;

    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: Container(
        height: 48,
        width: 328,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: AppShadows.shadow1,
        ),
        child: TextField(
          controller: widget.controller,
          onTap: widget.onTap,
          onChanged: (value) => setState(() {}),
          style: AppTypography.body1.copyWith(
            color: AppColors.neutral100,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: 'Buscar',
            hintStyle: AppTypography.body1.copyWith(color: AppColors.neutral50),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: AppIcons.getSearchIcon(state: IconState.defaultState),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: _buildSuffixIcon(hasText),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(bool hasText) {
    if (hasText) {
      // User typed -> show X (close)
      return IconButton(
        icon: AppIcons.getCloseIcon(state: IconState.defaultState),
        onPressed: _clearInput,
      );
    } else if (!_isFocused) {
      // Not focused -> show map or list icon
      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: widget.mode == SearchInputMode.map
            ? AppIcons.getMapIcon(state: IconState.enabled) // <- GREEN!!
            : AppIcons.getListIcon(state: IconState.enabled),
      );
    } else {
      // Focused but empty -> no icon
      return const SizedBox(width: 24);
    }
  }
}