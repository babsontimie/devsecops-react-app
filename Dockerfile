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

# Create high UID user
RUN addgroup -g 10100 appgroup \
    && adduser -u 10100 -G appgroup -S appuser

# Copy build files and set ownership
COPY --from=build /app/frontend/build /usr/share/nginx/html
RUN chown -R 10100:10100 /usr/share/nginx/html

# Switch to non-root user
USER 10100:10100

# Expose port
EXPOSE 80

# Add HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:80/ || exit 1

# Run NGINX as non-root
CMD ["nginx", "-g", "daemon off;"]
