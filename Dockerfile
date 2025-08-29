# Stage 1: Build React app
FROM node:20 AS build
WORKDIR /app
COPY ./frontend ./frontend
WORKDIR /app/frontend
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Create high UID user/group
RUN addgroup -g 10100 appgroup \
    && adduser -u 10100 -G appgroup -S appuser

# Copy build files
COPY --from=build /app/frontend/build /usr/share/nginx/html

# Replace default nginx config (port 8080 instead of 80)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Adjust permissions
RUN chown -R appuser:appgroup /usr/share/nginx/html

# Switch to non-root user
USER 10100:10100

EXPOSE 8080

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
