#!/bin/sh
# Fix Alpine musl single-label DNS resolution on Render:
# If BACKEND has no dot (e.g. opengym-api-1fj7), update the template so Nginx uses .onrender.internal
if [ -n "$BACKEND" ] && [ "$BACKEND" != "localhost" ] && [ "$BACKEND" != "127.0.0.1" ]; then
  case "$BACKEND" in
    *.*) ;;
    *)
      echo "Alpine DNS: Appending .onrender.internal to BACKEND '$BACKEND' in nginx template..."
      sed -i "s|\${BACKEND}|\${BACKEND}.onrender.internal|g" /etc/nginx/templates/default.conf.template
      ;;
  esac
fi
