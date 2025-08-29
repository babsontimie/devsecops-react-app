# Stage 1: Build React app
FROM node:20 AS build
WORKDIR /app
# Copy all files first
COPY ./frontend ./frontend
# Move into frontend folder
WORKDIR /app/frontend
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:alpine
# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# Copy build files
COPY --from=build /app/frontend/build /usr/share/nginx/html
# Change ownership of the files
RUN chown -R appuser:appgroup /usr/share/nginx/html
# Switch to non-root user
USER appuser

EXPOSE 80
# Add HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:80/ || exit 1
  
CMD ["nginx", "-g", "daemon off;"]
