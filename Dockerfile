# Stage 1: Build frontend assets
FROM node:18-alpine AS builder

WORKDIR /app
COPY . .

# Set Yarn network timeout to 10 minutes to avoid ESOCKETTIMEDOUT errors
RUN yarn config set network-timeout 600000

# Retry install once on failure
RUN yarn install || yarn install

# Build the app
RUN yarn build

# Stage 2: Serve with Nginx
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

# Remove default Nginx static content
RUN rm -rf ./*

# Copy built frontend from builder stage
COPY --from=builder /app/build .

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
