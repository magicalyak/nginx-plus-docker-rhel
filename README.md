# nginx-plus-docker-rhel

NGiNX Plus Docker image for RHEL 7

# What is nginx?

Nginx (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server). The nginx project started with a strong focus on high concurrency, high performance and low memory usage. It is licensed under the 2-clause BSD-like license and it runs on Linux, BSD variants, Mac OS X, Solaris, AIX, HP-UX, as well as on other *nix flavors. It also has a proof of concept port for Microsoft Windows.

> [wikipedia.org/wiki/Nginx](https://en.wikipedia.org/wiki/Nginx)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/nginx/logo.png)

# How to use this image

## Prerequisites

copy nginx-repo.crt and nginx-repo.key in the root diectory (Dockerfile copies them into the image)

This should run on a properly subscribed Red Hat Enterprise Linux system (the container will assume the subscription from the OS)

## Building the Dockerfile

```console
$ cd nginx-plus-docker-rhel
$ docker build -t magicalyak/nginx-plus-docker-rhel .
```

## Hosting default content

```console
$ docker run --name nginx-plus-rhel -p 80:80/tcp -p 443:443/tcp -p 8080:8080/tcp -d magicalyak/nginx-plus-docker-rhel
```

## Hosting some simple static content

```console
$ docker run --name nginx-plus-rhel -v /some/content:/usr/share/nginx/html:ro -p 80:80/tcp -p 443:443/tcp -p 8080:8080/tcp -d magicalyak/nginx-plus-docker-rhel
```
