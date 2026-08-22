import 'package:demo_shop/Core/Navigation/scaffoldKey.dart';
import 'package:demo_shop/Helper/logHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Defines the drawer menu items and their order.
enum DrawerItem { home, featured, search, cart, profile, logout }

@immutable
class DrawerState {
  final bool isOpen;
  final DrawerItem selectedItem;

  const DrawerState({this.isOpen = false, this.selectedItem = DrawerItem.home});

  DrawerState copyWith({bool? isOpen, DrawerItem? selectedItem}) {
    return DrawerState(
      isOpen: isOpen ?? this.isOpen,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawerState &&
          runtimeType == other.runtimeType &&
          isOpen == other.isOpen &&
          selectedItem == other.selectedItem;

  @override
  int get hashCode => isOpen.hashCode ^ selectedItem.hashCode;
}

class DrawerNotifier extends StateNotifier<DrawerState> {
  DrawerNotifier() : super(const DrawerState());

  // ─────────────────────────────────────────
  // Sync state with actual Scaffold drawer
  // ─────────────────────────────────────────

  void setOpenState(bool isOpen) {
    if (state.isOpen == isOpen) return;

    state = state.copyWith(isOpen: isOpen);
  }

  // ─────────────────────────────────────────
  // Open
  // ─────────────────────────────────────────

  void open() {
    final scaffold = scaffoldKey.currentState;

    if (scaffold == null) {
      coloredLog(
        'ScaffoldState is null',
        color: LogColor.red,
        tag: 'DrawerNotifier',
      );
      return;
    }

    if (scaffold.isDrawerOpen) return;

    scaffold.openDrawer();

    state = state.copyWith(isOpen: true);

    coloredLog('drawer opened', color: LogColor.green, tag: 'DrawerNotifier');
  }

  // ─────────────────────────────────────────
  // Close
  // ─────────────────────────────────────────

  void close() {
    final scaffold = scaffoldKey.currentState;

    if (scaffold == null) {
      coloredLog(
        'ScaffoldState is null',
        color: LogColor.red,
        tag: 'DrawerNotifier',
      );
      return;
    }

    if (!scaffold.isDrawerOpen) return;

    scaffold.closeDrawer();

    state = state.copyWith(isOpen: false);

    coloredLog('drawer closed', color: LogColor.green, tag: 'DrawerNotifier');
  }

  // ─────────────────────────────────────────
  // Toggle
  // ─────────────────────────────────────────

  void toggle() {
    final scaffold = scaffoldKey.currentState;

    if (scaffold == null) {
      coloredLog(
        'ScaffoldState is null',
        color: LogColor.red,
        tag: 'DrawerNotifier',
      );
      return;
    }

    if (scaffold.isDrawerOpen) {
      close();
    } else {
      open();
    }
  }

  // ─────────────────────────────────────────
  // Select menu item
  // ─────────────────────────────────────────

  void selectItem(DrawerItem item, {bool closeOnSelect = true}) {
    state = state.copyWith(selectedItem: item);

    if (closeOnSelect) {
      close();
    }
  }
}

final drawerProvider = StateNotifierProvider<DrawerNotifier, DrawerState>((
  ref,
) {
  return DrawerNotifier();
});
