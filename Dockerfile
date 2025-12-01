# Use a newer, stable NGINX base image with patched packages
FROM nginx:1.25.2-bookworm

# Update packages and install only needed modules
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx-module-xslt \
        # remove old cache
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy your HTML and JS
COPY html /usr/share/nginx/html

# Copy custom nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port
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

