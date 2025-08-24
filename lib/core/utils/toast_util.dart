import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showErrorToast(String errorMessage) {
  toastification.show(
    type: ToastificationType.error,
    style: ToastificationStyle.flatColored,
    title: Text(errorMessage),
    closeOnClick: true,
    showIcon: false,
    closeButtonShowType: CloseButtonShowType.none,
    showProgressBar: false,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 5),
  );
}

void showSuccessToast(String message) {
  toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    autoCloseDuration: const Duration(seconds: 4),
    showProgressBar: false,
    closeOnClick: true,
    alignment: Alignment.bottomCenter,
    title: Text(message),
  );
}
