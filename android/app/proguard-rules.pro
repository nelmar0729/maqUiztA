# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.view.** { *; }

# Keep generated code
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Prevent obfuscation of classes with @Keep
-keep @androidx.annotation.Keep class * { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Optimize code but don’t strip essential methods
-dontwarn io.flutter.**
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
