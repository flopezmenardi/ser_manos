import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/atoms/icons.dart';

class HeaderModal extends StatelessWidget {
  final VoidCallback onClose;

  const HeaderModal({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: onClose,
          child: AppIcons.getCloseIcon(state: IconState.defaultState),
        ),
      ),
    );
  }
}
