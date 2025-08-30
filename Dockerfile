# Use Docker Buildx to support multi-arch builds: linux/amd64, linux/arm64

# Stage 1: Build React app
FROM --platform=$BUILDPLATFORM node:20 AS build
WORKDIR /app
COPY ./frontend ./frontend
WORKDIR /app/frontend
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve with NGINX
FROM --platform=$BUILDPLATFORM nginx:alpine
# Create a high UID non-root user
RUN addgroup -g 10100 appgroup \
    && adduser -u 10100 -G appgroup -S appuser

# Copy React build files
COPY --from=build /app/frontend/build /usr/share/nginx/html

# Fix ownership
RUN chown -R appuser:appgroup /usr/share/nginx/html

# Switch to non-root user
USER 10100:10100

# Expose port
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:80/ || exit 1

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]
