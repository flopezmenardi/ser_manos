import 'package:flutter/material.dart';

import '../../atoms/icons.dart';
import '../../molecules/status_bar/status_bar.dart';

class HeaderModal extends StatelessWidget {
  final VoidCallback onClose;

  const HeaderModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const StatusBar(variant: StatusBarVariant.form),
        Container(
          height: 64,
          width: double.infinity,
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: GestureDetector(onTap: onClose, child: AppIcons.getCloseIcon(state: IconState.closeColor)),
          ),
        ),
      ],
    );
  }
}
