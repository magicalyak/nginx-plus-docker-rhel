FROM registry.access.redhat.com/ubi7:latest
LABEL maintainer="tom.gamull@nginx.com"

# Labels consumed by Red Hat build service
LABEL Component="nginx" \
      Name="magicalyak/nginx-plus-docker-rhel" \
      Version="1.21.1" \
      Release="1"

# Labels could be consumed by OpenShift
LABEL io.k8s.description="nginx [engine x] is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server, originally written by Igor Sysoev." \
      io.k8s.display-name="nginx 1.21.1" \
      io.openshift.expose-services="80:http" \
      io.openshift.tags="nginx"

# Update image
RUN yum update --disableplugin=subscription-manager -y && \
    rm -rf /var/cache/yum && \
    mkdir -p /etc/ssl/nginx

## Install Nginx Plus
# Download certificate and key from the customer portal https://cs.nginx.com
# and copy to the build context and set correct permissions
COPY nginx-repo.crt /etc/ssl/nginx/
COPY nginx-repo.key /etc/ssl/nginx/

RUN yum install -y --disableplugin=subscription-manager ca-certificates wget openssl && \
    wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.4.repo && \
    yum install -y --disableplugin=subscription-manager nginx-plus && \
    rm -rf /etc/nginx/conf.d/default.conf && \
    ## Optional: Install NGINX Plus Modules from repo
    # See https://www.nginx.com/products/nginx/modules
    #yum install -y --disableplugin=subscription-manager nginx-plus-module-modsecurity && \
    #yum install -y --disableplugin=subscription-manager nginx-plus-module-geoip && \
    #yum install -y --disableplugin=subscription-manager nginx-plus-module-njs && \
    rm -rf /var/cache/yum


# Optional: COPY over any of your SSL certs in /etc/ssl for HTTPS servers
# e.g.
COPY etc/ssl   /etc/ssl

# COPY /etc/nginx (Nginx configuration) directory
COPY etc/nginx /etc/nginx

# Check imported NGINX config
RUN nginx -t && \
    # Forward request logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    # ln -sf /dev/stdout /var/log/nginx/stream.log \
    # **Remove the Nginx Plus cert/keys from the image**
    # rm /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key
    nginx -T

COPY html/demo-index.html /usr/share/nginx/html

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80 443 8080
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
