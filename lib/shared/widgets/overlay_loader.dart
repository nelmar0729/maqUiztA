import 'package:flutter/material.dart';

/*
 * Usage
 * // Show overlay loader
OverlayLoader.show(context, message: "Loading...");

// Hide overlay loader
OverlayLoader.hide();

 */

class OverlayLoader {
  static OverlayEntry? _currentLoader;
  static _OverlayLoaderState? _loaderState; // FIX: now nullable and reset

  static void show(BuildContext context, {String? message}) {
    if (_currentLoader != null) return; // Prevent duplicate overlays

    final loader = _OverlayLoader(
      message: message,
      onInit: (state) => _loaderState = state,
    );
    _currentLoader = OverlayEntry(builder: (context) => loader);

    Overlay.of(context, rootOverlay: true).insert(_currentLoader!);
  }

  static void hide() {
    if (_currentLoader != null && (_loaderState?.mounted ?? false)) {
      _loaderState?.fadeOut(() {
        _currentLoader?.remove();
        _currentLoader = null;
        _loaderState = null; // Reset for future use
      });
    } else {
      _currentLoader?.remove();
      _currentLoader = null;
      _loaderState = null; // Reset for future use
    }
  }
}

class _OverlayLoader extends StatefulWidget {
  final String? message;
  final void Function(_OverlayLoaderState state)? onInit;

  const _OverlayLoader({this.message, this.onInit});

  @override
  _OverlayLoaderState createState() => _OverlayLoaderState();
}

class _OverlayLoaderState extends State<_OverlayLoader>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.onInit?.call(this);

    // Fade in after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1.0);
    });
  }

  void fadeOut(VoidCallback onEnd) {
    setState(() => _opacity = 0.0);
    Future.delayed(const Duration(milliseconds: 250), onEnd);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 250),
      child: Stack(
        children: [
          ModalBarrier(dismissible: false, color: Colors.black45),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _AnimatedSpinner(),
                if (widget.message != null) ...[
                  const SizedBox(height: 16),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.message!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Animated spinner with pulse effect
class _AnimatedSpinner extends StatefulWidget {
  const _AnimatedSpinner();

  @override
  State<_AnimatedSpinner> createState() => _AnimatedSpinnerState();
}

class _AnimatedSpinnerState extends State<_AnimatedSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = Tween(
    begin: 1.0,
    end: 1.2,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: const CircularProgressIndicator(
        strokeWidth: 4,
        color: Colors.blueAccent,
      ),
    );
  }
}
