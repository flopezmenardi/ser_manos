import 'package:flutter/material.dart';
import 'package:ser_manos/generated/l10n/app_localizations.dart';

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
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
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
        width: double.infinity,
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
            hintText: AppLocalizations.of(context)!.search,
            hintStyle: AppTypography.body1.copyWith(color: AppColors.neutral50),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: AppIcons.getSearchIcon(state: IconState.defaultState),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: _buildSuffixIcon(hasText),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(bool hasText) {
    if (_isFocused && hasText) {
      // Si el usuario está escribiendo -> mostrar el close icon
      return IconButton(icon: AppIcons.getCloseIcon(state: IconState.defaultState), onPressed: _clearInput);
    } else {
      // En cualquier otro caso (no enfocado o vacío) -> mostrar el ListIcon
      return GestureDetector(
        onTap: widget.onSortByProximityRequested,
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AppIcons.getListIcon(state: IconState.enabled),
        ),
      );
    }
  }
}
