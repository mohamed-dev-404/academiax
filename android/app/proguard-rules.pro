# Tell R8 to ignore missing okhttp references inside third-party libraries
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn com.yalantis.ucrop.**

# Keep ucrop classes from being altered during minification
-keep class com.yalantis.ucrop.** { *; }
-keep interface com.yalantis.ucrop.** { *; }