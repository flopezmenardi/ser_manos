import 'package:flutter/cupertino.dart';
import 'package:ser_manos/design_system/atoms/close_icon.dart';

class HeaderModalSermanos extends StatelessWidget {
  final VoidCallback onClose;

  const HeaderModalSermanos({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          const SizedBox(width: 16), // left padding
          GestureDetector(
            onTap: onClose,
            child: CloseIcon.get(state: CloseIconState.defaultState),
          ),
        ],
      ),
    );
  }
}