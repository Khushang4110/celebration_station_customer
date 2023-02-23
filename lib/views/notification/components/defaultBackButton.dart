import 'package:flutter/material.dart';

import '../../../Utils/colors_utils.dart';

class DefaultBackButton extends StatelessWidget {
  const DefaultBackButton({
    Key ?key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios, color: ColorUtils.primaryColor),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}