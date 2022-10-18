FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.utf8

RUN apt-get update && apt-get install -y \
  locales \
  postfix \
  syslog-ng \
  syslog-ng-core \
  && rm -rf /var/lib/apt/lists/*

RUN localedef \
  -i en_US \
  -c \
  -f UTF-8 \
  -A /usr/share/locale/locale.alias \
  en_US.UTF-8

RUN sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf

#Setup postfix chroot environment
RUN cp -rf \
  /etc/host.conf \
  /etc/hosts \
  /etc/localtime \
  /etc/nsswitch.conf \
  /etc/resolv.conf \
  /etc/services \
  /etc/ssl \
  /var/spool/postfix/etc/

ADD ./postfix/relay_maps /etc/postfix/relay_maps

COPY install-postfix-relay.sh /opt/install-postfix-relay.sh

#expose on tailscale ip only on ip:port->587

ENTRYPOINT ["/opt/install-postfix-relay.sh"]
