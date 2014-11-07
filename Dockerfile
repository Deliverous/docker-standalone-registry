FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

ADD sources.list /etc/apt/sources.list

RUN \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python-pip \
        python-dev \
        liblzma-dev \
        libevent1-dev \
        nginx \
        build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && pip install docker-registry==0.9.0 \
    && pip install supervisor-stdout==0.1.1 \
    && chown -R www-data:www-data /var/lib/nginx

ADD nginx.conf /etc/nginx/nginx.conf
ADD docker-registry.conf /etc/nginx/docker-registry.conf
ADD registry.yaml /etc/registry/registry.yaml

WORKDIR /etc/nginx

ENV DOCKER_REGISTRY_CONFIG /etc/registry/registry.yaml
ENV SETTINGS_FLAVOR production

EXPOSE 443
VOLUME /config

CMD ["/usr/bin/supervisord"]
