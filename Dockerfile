# Use the official Nginx image from Docker Hub
FROM nginx:alpine

# Copy the HTML file into the Nginx web directory
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
