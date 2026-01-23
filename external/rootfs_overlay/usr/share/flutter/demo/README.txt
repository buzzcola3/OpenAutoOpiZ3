Bare-minimum Flutter demo

This directory includes a tiny Flutter app template in:
- /usr/share/flutter/demo/app/

To deploy a runnable demo for flutter-pi, build the app on your host and copy
these outputs into this directory on the target:
- /usr/share/flutter/demo/flutter_assets/
- /usr/share/flutter/demo/libapp.so

Suggested build steps (run on your host in the app folder):
1) flutter config --enable-linux-desktop
2) flutter pub get
3) flutter build bundle
4) Use flutter-pi tooling to produce libapp.so for aarch64

Then copy build/flutter_assets/* to flutter_assets/ and the produced libapp.so
to /usr/share/flutter/demo/libapp.so.
