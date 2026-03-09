import 'package:flutter/material.dart';

class AppSpacingTokens {
  AppSpacingTokens._();

  static const double spacing1x = 4;
  static const double spacing2x = 8;
  static const double spacing3x = 12;
  static const double spacing4x = 16;
  static const double spacing5x = 20;
  static const double spacing6x = 24;
  static const double spacing7x = 28;
  static const double spacing8x = 32;
  static const double spacing9x = 36;
  static const double spacing10x = 40;
  static const double spacing11x = 44;
  static const double spacing12x = 48;
}


class AppPaddingTokens {
  AppPaddingTokens._();

  static const double padding1x = 4;
  static const double padding2x = 8;
  static const double padding3x = 12;
  static const double padding4x = 16;
  static const double padding5x = 20;
  static const double padding6x = 24;
  static const double padding7x = 28;
  static const double padding8x = 32;
  static const double padding9x = 36;
  static const double padding10x = 40;
  static const double padding11x = 44;
  static const double padding12x = 48;
}


class AppSizeTokens {
  AppSizeTokens._();

  static const double size1x = 4;
  static const double size2x = 8;
  static const double size3x = 12;
  static const double size4x = 16;
  static const double size5x = 20;
  static const double size6x = 24;
  static const double size7x = 28;
  static const double size8x = 32;
  static const double size9x = 36;
  static const double size10x = 40;
  static const double size11x = 44;
  static const double size12x = 48;
  static const double size13x = 52;
  static const double size14x = 56;
  static const double size15x = 60;
  static const double size16x = 64;
  static const double size17x = 68;
  static const double size18x = 72;
  static const double size19x = 76;
  static const double size20x = 80;
}

class AppBorderRadiusTokens {
  AppBorderRadiusTokens._();

  static const double size1x = 4;
  static const double size2x = 8;
  static const double size3x = 12;
  static const double size4x = 16;
  static const double size5x = 20;
  static const double size6x = 24;
  static const double size7x = 28;
  static const double size8x = 32;
  static const double size9x = 36;
  static const double size10x = 40;
  static const double size11x = 44;
  static const double size12x = 48;

  static final BorderRadius circular1x = BorderRadius.circular(size1x);
  static final BorderRadius circular2x = BorderRadius.circular(size2x);
  static final BorderRadius circular3x = BorderRadius.circular(size3x);
  static final BorderRadius circular4x = BorderRadius.circular(size4x);
  static final BorderRadius circular5x = BorderRadius.circular(size5x);
  static final BorderRadius circular6x = BorderRadius.circular(size6x);
  static final BorderRadius circular7x = BorderRadius.circular(size7x);
  static final BorderRadius circular8x = BorderRadius.circular(size8x);
  static final BorderRadius circular9x = BorderRadius.circular(size9x);
  static final BorderRadius circular10x = BorderRadius.circular(size10x);
  static final BorderRadius circular11x = BorderRadius.circular(size11x);
  static final BorderRadius circular12x = BorderRadius.circular(size12x);
}

class AppSpacing {
  AppSpacing._();

  static const double _baseWidth = 375;
  static const double _minScale = 0.85;
  static const double _maxScale = 1.3;

  static double _scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = width / _baseWidth;
    return scale.clamp(_minScale, _maxScale);
  }

  static double value(BuildContext context, double size) {
    return size * _scale(context);
  }

  static double radiusValue(BuildContext context, double size) {
    return value(context, size);
  }

  static EdgeInsets all(BuildContext context, double size) =>
      EdgeInsets.all(value(context, size));

  static EdgeInsets fromLTRB(
    BuildContext context,
    double left,
    double top,
    double right,
    double bottom,
  ) => EdgeInsets.fromLTRB(
    value(context, left),
    value(context, top),
    value(context, right),
    value(context, bottom),
  );

  static EdgeInsets fromLTRBWithBottomInset(
    BuildContext context, {
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
    double bottomInset = 0,
  }) => EdgeInsets.fromLTRB(
    value(context, left),
    value(context, top),
    value(context, right),
    value(context, bottom) + bottomInset,
  );

  static EdgeInsets symmetric({
    required BuildContext context,
    double horizontal = 0,
    double vertical = 0,
  }) => EdgeInsets.symmetric(
    horizontal: value(context, horizontal),
    vertical: value(context, vertical),
  );

  static EdgeInsets only({
    required BuildContext context,
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: value(context, left),
    right: value(context, right),
    top: value(context, top),
    bottom: value(context, bottom),
  );

  static BorderRadius circular(BuildContext context, double size) =>
      BorderRadius.circular(radiusValue(context, size));

  static BorderRadius verticalRadius(
    BuildContext context, {
    double top = 0,
    double bottom = 0,
  }) => BorderRadius.vertical(
    top: Radius.circular(radiusValue(context, top)),
    bottom: Radius.circular(radiusValue(context, bottom)),
  );

  static BorderRadius onlyRadius({
    required BuildContext context,
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(radiusValue(context, topLeft)),
    topRight: Radius.circular(radiusValue(context, topRight)),
    bottomLeft: Radius.circular(radiusValue(context, bottomLeft)),
    bottomRight: Radius.circular(radiusValue(context, bottomRight)),
  );

  static RoundedRectangleBorder roundedRectangle(
    BuildContext context,
    double size,
  ) => RoundedRectangleBorder(borderRadius: circular(context, size));

  static SizedBox h(BuildContext context, double size) =>
      SizedBox(height: value(context, size));
  static SizedBox w(BuildContext context, double size) =>
      SizedBox(width: value(context, size));
  static SizedBox square(BuildContext context, double size) =>
      SizedBox(height: value(context, size), width: value(context, size));


  static SizedBox h4(BuildContext c) => h(c, 4);
  static SizedBox h8(BuildContext c) => h(c, 8);
  static SizedBox h12(BuildContext c) => h(c, 12);
  static SizedBox h16(BuildContext c) => h(c, 16);
  static SizedBox h20(BuildContext c) => h(c, 20);
  static SizedBox h24(BuildContext c) => h(c, 24);
  static SizedBox h32(BuildContext c) => h(c, 32);
  static SizedBox h40(BuildContext c) => h(c, 40);
  static SizedBox h48(BuildContext c) => h(c, 48);

  static SizedBox w4(BuildContext c) => w(c, 4);
  static SizedBox w8(BuildContext c) => w(c, 8);
  static SizedBox w12(BuildContext c) => w(c, 12);
  static SizedBox w16(BuildContext c) => w(c, 16);
  static SizedBox w20(BuildContext c) => w(c, 20);
  static SizedBox w24(BuildContext c) => w(c, 24);
  static SizedBox w32(BuildContext c) => w(c, 32);

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 900
        ? AppPaddingTokens.padding12x
        : width >= 600
            ? AppPaddingTokens.padding8x
            : AppPaddingTokens.padding5x;

    return fromLTRB(
      context,
      horizontal,
      AppPaddingTokens.padding5x,
      horizontal,
      AppPaddingTokens.padding7x,
    );
  }

  static Widget divider(
    BuildContext context, {
    double thickness = 1,
    double verticalSpace = 16,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value(context, verticalSpace)),
      child: Divider(
        thickness: value(context, thickness),
        color: color ?? Colors.grey.shade300,
      ),
    );
  }

  static Widget verticalDivider(
    BuildContext context, {
    double thickness = 1,
    double horizontalSpace = 16,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: value(context, horizontalSpace),
      ),
      child: VerticalDivider(
        thickness: value(context, thickness),
        color: color ?? Colors.grey.shade300,
      ),
    );
  }
}

extension ResponsiveSpacing on num {
  double r(BuildContext context) {
    const baseWidth = 375;
    const minScale = 0.85;
    const maxScale = 1.3;

    final width = MediaQuery.of(context).size.width;
    final scale = (width / baseWidth).clamp(minScale, maxScale);

    return this * scale;
  }
}
