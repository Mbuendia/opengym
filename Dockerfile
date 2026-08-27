# Multi-stage Dockerfile: build React frontend, fetch exercise media, and run unified Node server

# Stage 1: Build Frontend
FROM node:22-alpine AS build
WORKDIR /app
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm ci 2>/dev/null || npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Fetch Exercise Media (images + GIFs ~140 MB)
FROM alpine:latest AS media
WORKDIR /media
RUN apk add --no-cache git && \
    git clone --depth 1 https://github.com/hasaneyldrm/exercises-dataset /tmp/ds && \
    mkdir -p /out/img /out/gif && \
    cp /tmp/ds/images/*.jpg /out/img/ && \
    cp /tmp/ds/videos/*.gif /out/gif/

# Stage 3: Production Server
FROM node:22-alpine
WORKDIR /app
COPY api/package.json api/package-lock.json* ./
RUN npm install --omit=dev && npm cache clean --force
COPY api/ ./
COPY --from=build /app/dist ./public
COPY --from=media /out/img ./public/img
COPY --from=media /out/gif ./public/gif

ENV NODE_ENV=production
ENV PORT=10000
ENV STATIC_DIR=./public
ENV DATA_DIR=./data

EXPOSE 10000
CMD ["node", "server.js"]
