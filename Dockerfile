# Use CentOS base image
FROM rockylinux:8-minimal

# Install Apache HTTP server
RUN dnf -y update && \
    dnf -y install httpd && \
    dnf clean all

# Add custom index.html
RUN echo "hello Jenkins " > /var/www/html/index.html

# Expose HTTP port
EXPOSE 80

# Start Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
