import 'package:flutter/material.dart';

import 'lumos_button.dart';
import 'lumos_danger_button.dart';
import 'lumos_icon_button.dart';
import 'lumos_outline_button.dart';
import 'lumos_primary_button.dart';
import 'lumos_secondary_button.dart';

class LumosActionButtonPayload {
  const LumosActionButtonPayload({
    required this.label,
    this.key,
    this.onPressed,
    this.size = LumosButtonConst.defaultSize,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
  });

  final Key? key;
  final String label;
  final VoidCallback? onPressed;
  final LumosButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;
}

class LumosIconButtonPayload {
  const LumosIconButtonPayload({
    required this.icon,
    this.key,
    this.onPressed,
    this.size,
    this.tooltip,
    this.variant = LumosIconButtonVariant.standard,
    this.selected = false,
    this.selectedIcon,
  });

  final Key? key;
  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final String? tooltip;
  final LumosIconButtonVariant variant;
  final bool selected;
  final IconData? selectedIcon;
}

abstract interface class LumosActionButtonWidgetFactory {
  Widget create({required LumosActionButtonPayload payload});
}

abstract interface class LumosIconButtonWidgetFactory {
  LumosIconButton create({required LumosIconButtonPayload payload});
}

final class LumosPrimaryButtonWidgetFactory
    implements LumosActionButtonWidgetFactory {
  const LumosPrimaryButtonWidgetFactory();

  @override
  LumosPrimaryButton create({required LumosActionButtonPayload payload}) {
    return LumosPrimaryButton(
      key: payload.key,
      label: payload.label,
      onPressed: payload.onPressed,
      size: payload.size,
      isLoading: payload.isLoading,
      icon: payload.icon,
      expanded: payload.expanded,
    );
  }
}

final class LumosSecondaryButtonWidgetFactory
    implements LumosActionButtonWidgetFactory {
  const LumosSecondaryButtonWidgetFactory();

  @override
  LumosSecondaryButton create({required LumosActionButtonPayload payload}) {
    return LumosSecondaryButton(
      key: payload.key,
      label: payload.label,
      onPressed: payload.onPressed,
      size: payload.size,
      isLoading: payload.isLoading,
      icon: payload.icon,
      expanded: payload.expanded,
    );
  }
}

final class LumosOutlineButtonWidgetFactory
    implements LumosActionButtonWidgetFactory {
  const LumosOutlineButtonWidgetFactory();

  @override
  LumosOutlineButton create({required LumosActionButtonPayload payload}) {
    return LumosOutlineButton(
      key: payload.key,
      label: payload.label,
      onPressed: payload.onPressed,
      size: payload.size,
      isLoading: payload.isLoading,
      icon: payload.icon,
      expanded: payload.expanded,
    );
  }
}

final class LumosDangerButtonWidgetFactory
    implements LumosActionButtonWidgetFactory {
  const LumosDangerButtonWidgetFactory();

  @override
  LumosDangerButton create({required LumosActionButtonPayload payload}) {
    return LumosDangerButton(
      key: payload.key,
      label: payload.label,
      onPressed: payload.onPressed,
      size: payload.size,
      isLoading: payload.isLoading,
      icon: payload.icon,
      expanded: payload.expanded,
    );
  }
}

final class LumosTextButtonWidgetFactory
    implements LumosActionButtonWidgetFactory {
  const LumosTextButtonWidgetFactory();

  @override
  LumosButton create({required LumosActionButtonPayload payload}) {
    return LumosButton(
      key: payload.key,
      label: payload.label,
      onPressed: payload.onPressed,
      type: LumosButtonType.text,
      size: payload.size,
      isLoading: payload.isLoading,
      icon: payload.icon,
      expanded: payload.expanded,
    );
  }
}

final class LumosIconButtonFactoryImpl implements LumosIconButtonWidgetFactory {
  const LumosIconButtonFactoryImpl();

  @override
  LumosIconButton create({required LumosIconButtonPayload payload}) {
    return LumosIconButton(
      key: payload.key,
      icon: payload.icon,
      onPressed: payload.onPressed,
      size: payload.size,
      tooltip: payload.tooltip,
      variant: payload.variant,
      selected: payload.selected,
      selectedIcon: payload.selectedIcon,
    );
  }
}

abstract final class LumosButtonFactory {
  LumosButtonFactory._();

  static const LumosPrimaryButtonWidgetFactory _primaryFactory =
      LumosPrimaryButtonWidgetFactory();
  static const LumosSecondaryButtonWidgetFactory _secondaryFactory =
      LumosSecondaryButtonWidgetFactory();
  static const LumosOutlineButtonWidgetFactory _outlineFactory =
      LumosOutlineButtonWidgetFactory();
  static const LumosDangerButtonWidgetFactory _dangerFactory =
      LumosDangerButtonWidgetFactory();
  static const LumosTextButtonWidgetFactory _textFactory =
      LumosTextButtonWidgetFactory();
  static const LumosIconButtonFactoryImpl _iconFactory =
      LumosIconButtonFactoryImpl();

  static final Map<LumosButtonType, LumosActionButtonWidgetFactory>
  _actionFactoryRegistry = <LumosButtonType, LumosActionButtonWidgetFactory>{
    LumosButtonType.primary: _primaryFactory,
    LumosButtonType.secondary: _secondaryFactory,
    LumosButtonType.outline: _outlineFactory,
    LumosButtonType.danger: _dangerFactory,
    LumosButtonType.text: _textFactory,
  };

  static Widget build({
    required LumosButtonType type,
    required String label,
    Key? key,
    VoidCallback? onPressed,
    LumosButtonSize size = LumosButtonConst.defaultSize,
    bool isLoading = false,
    IconData? icon,
    bool expanded = false,
  }) {
    final LumosActionButtonPayload payload = LumosActionButtonPayload(
      key: key,
      label: label,
      onPressed: onPressed,
      size: size,
      isLoading: isLoading,
      icon: icon,
      expanded: expanded,
    );
    return _resolveActionFactory(type: type).create(payload: payload);
  }

  static LumosPrimaryButton primary({
    required String label,
    Key? key,
    VoidCallback? onPressed,
    LumosButtonSize size = LumosButtonConst.defaultSize,
    bool isLoading = false,
    IconData? icon,
    bool expanded = false,
  }) {
    final LumosActionButtonPayload payload = LumosActionButtonPayload(
      key: key,
      label: label,
      onPressed: onPressed,
      size: size,
      isLoading: isLoading,
      icon: icon,
      expanded: expanded,
    );
    return _primaryFactory.create(payload: payload);
  }

  static LumosSecondaryButton secondary({
    required String label,
    Key? key,
    VoidCallback? onPressed,
    LumosButtonSize size = LumosButtonConst.defaultSize,
    bool isLoading = false,
    IconData? icon,
    bool expanded = false,
  }) {
    final LumosActionButtonPayload payload = LumosActionButtonPayload(
      key: key,
      label: label,
      onPressed: onPressed,
      size: size,
      isLoading: isLoading,
      icon: icon,
      expanded: expanded,
    );
    return _secondaryFactory.create(payload: payload);
  }

  static LumosOutlineButton outline({
    required String label,
    Key? key,
    VoidCallback? onPressed,
    LumosButtonSize size = LumosButtonConst.defaultSize,
    bool isLoading = false,
    IconData? icon,
    bool expanded = false,
  }) {
    final LumosActionButtonPayload payload = LumosActionButtonPayload(
      key: key,
      label: label,
      onPressed: onPressed,
      size: size,
      isLoading: isLoading,
      icon: icon,
      expanded: expanded,
    );
    return _outlineFactory.create(payload: payload);
  }

  static LumosDangerButton danger({
    required String label,
    Key? key,
    VoidCallback? onPressed,
    LumosButtonSize size = LumosButtonConst.defaultSize,
    bool isLoading = false,
    IconData? icon,
    bool expanded = false,
  }) {
    final LumosActionButtonPayload payload = LumosActionButtonPayload(
      key: key,
      label: label,
      onPressed: onPressed,
      size: size,
      isLoading: isLoading,
      icon: icon,
      expanded: expanded,
    );
    return _dangerFactory.create(payload: payload);
  }

  static LumosButton text({
    required String label,
    Key? key,
    VoidCallback? onPressed,
    LumosButtonSize size = LumosButtonConst.defaultSize,
    bool isLoading = false,
    IconData? icon,
    bool expanded = false,
  }) {
    final LumosActionButtonPayload payload = LumosActionButtonPayload(
      key: key,
      label: label,
      onPressed: onPressed,
      size: size,
      isLoading: isLoading,
      icon: icon,
      expanded: expanded,
    );
    return _textFactory.create(payload: payload);
  }

  static LumosIconButton icon({
    required IconData icon,
    Key? key,
    VoidCallback? onPressed,
    double? size,
    String? tooltip,
    LumosIconButtonVariant variant = LumosIconButtonVariant.standard,
    bool selected = false,
    IconData? selectedIcon,
  }) {
    final LumosIconButtonPayload payload = LumosIconButtonPayload(
      key: key,
      icon: icon,
      onPressed: onPressed,
      size: size,
      tooltip: tooltip,
      variant: variant,
      selected: selected,
      selectedIcon: selectedIcon,
    );
    return _iconFactory.create(payload: payload);
  }

  static LumosActionButtonWidgetFactory _resolveActionFactory({
    required LumosButtonType type,
  }) {
    final LumosActionButtonWidgetFactory? registeredFactory =
        _actionFactoryRegistry[type];
    if (registeredFactory case final LumosActionButtonWidgetFactory factory) {
      return factory;
    }
    return _textFactory;
  }
}
