import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '/shared/widgets/snackbar.dart';

Future<T?> safeApiCall<T>(
  BuildContext context,
  Future<T> Function() apiCall,
) async {
  final connectivityResult = await Connectivity().checkConnectivity();

  // 🔎 If no connectivity detected before calling API
  if (connectivityResult == ConnectivityResult.none) {
    AppSnack.show(context, "No Internet connection 🚫", SnackType.error);
    return null;
  }

  try {
    return await apiCall();
  } catch (e) {
    String message = "Something went wrong, please try again.";

    // 🔎 Extra protection if device is offline after API call starts
    if (e.toString().contains("Failed host lookup") ||
        e.toString().contains("SocketException") ||
        e.toString().contains("Connection reset by peer")) {
      message = "No Internet connection 🚫";
    }

    AppSnack.show(context, message, SnackType.error);
    return null;
  }
}
