# Use a newer patched NGINX base image
FROM nginx:1.25.3-bookworm

# Update OS packages and upgrade vulnerable package
RUN apt-get update && \
    apt-get install -y --only-upgrade abseil/libabsl20220623 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy HTML and JS files
COPY html /usr/share/nginx/html

# Copy custom nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]



# # Use official NGINX base image
# FROM nginx:latest

# # Copy static HTML and JS
# COPY html /usr/share/nginx/html

# # Copy custom NGINX configuration
# COPY nginx.conf /etc/nginx/nginx.conf

# # Expose port 80
# EXPOSE 80

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]

