# Multi-stage Dockerfile: build React frontend and run unified Node server
FROM node:22-alpine AS build
WORKDIR /app
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm ci 2>/dev/null || npm install
COPY frontend/ ./
RUN npm run build

FROM node:22-alpine
WORKDIR /app
COPY api/package.json api/package-lock.json* ./
RUN npm install --omit=dev && npm cache clean --force
COPY api/ ./
COPY --from=build /app/dist ./public

ENV NODE_ENV=production
ENV PORT=10000
ENV STATIC_DIR=./public
ENV DATA_DIR=./data

EXPOSE 10000
CMD ["node", "server.js"]
