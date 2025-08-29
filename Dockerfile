# Stage 1: Build React app
FROM node:18 AS build
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
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
