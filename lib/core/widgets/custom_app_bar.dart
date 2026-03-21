import 'package:flutter/material.dart';

import '../utils/app_strings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.centerTitle,
    this.leading,
    this.leadingWidth,
  });

  final Widget? title;
  final bool? centerTitle;
  final Widget? leading;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: centerTitle,
      leading: Tooltip(message: AppStrings.back, child: leading),
      leadingWidth: leadingWidth,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
