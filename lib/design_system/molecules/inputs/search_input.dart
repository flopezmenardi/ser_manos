import 'package:flutter/material.dart';

import '../../atoms/icons.dart';
import '../../tokens/colors.dart';
import '../../tokens/shadow.dart';
import '../../tokens/typography.dart';

enum SearchInputMode { map, list }

class SearchInput extends StatefulWidget {
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;
  final SearchInputMode mode;
  final VoidCallback? onSortByProximityRequested;
  final TextEditingController? controller;

  const SearchInput({
    super.key,
    required this.onChanged,
    required this.onSubmitted,
    required this.mode,
    this.onSortByProximityRequested,
    this.controller,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late final TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      setState(() {}); // Update UI on text changes
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose(); // Dispose if we created it internally
    }
    super.dispose();
  }

  void _clearInput() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = _controller.text.isNotEmpty;

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
          controller: _controller,
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {});
          },
          onSubmitted: widget.onSubmitted,
          style: AppTypography.body1.copyWith(color: AppColors.neutral100),
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
      // User typed -> show clear button
      return IconButton(
        icon: AppIcons.getCloseIcon(state: IconState.defaultState),
        onPressed: _clearInput,
      );
    } else if (!_isFocused) {
      // Not focused -> show map/list icon that can be pressed to trigger proximity sort
      return GestureDetector(
        onTap: widget.onSortByProximityRequested,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child:
              widget.mode == SearchInputMode.map
                  ? AppIcons.getMapIcon(state: IconState.enabled)
                  : AppIcons.getListIcon(state: IconState.enabled),
        ),
      );
    } else {
      // Focused but empty -> no icon, keep space
      return const SizedBox(width: 24);
    }
  }
}
