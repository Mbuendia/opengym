#!/bin/sh
# Fix Alpine musl single-label DNS resolution on Render
if [ -n "$BACKEND" ] && [ "$BACKEND" != "localhost" ] && [ "$BACKEND" != "127.0.0.1" ]; then
  case "$BACKEND" in
    *.*) ;;
    *)
      if ! nslookup "$BACKEND" >/dev/null 2>&1 && ! getent hosts "$BACKEND" >/dev/null 2>&1; then
        echo "Alpine DNS: '$BACKEND' not found, appending .onrender.internal for Render..."
        export BACKEND="${BACKEND}.onrender.internal"
      fi
      ;;
  esac
fi
