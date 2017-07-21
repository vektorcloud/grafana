FROM quay.io/vektorcloud/glibc:latest

ENV GRAFANA_PACKAGE grafana-4.4.1.linux-x64.tar.gz 

RUN set -ex \
 && apk add --no-cache openssl fontconfig bash curl \
 && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community dumb-init \
 && wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/$GRAFANA_PACKAGE \
 && tar -xvf grafana-* \
 && rm -v grafana-*tar.gz \
 && mv grafana-* /grafana \
 && mkdir /var/lib/grafana \
 && ln -s /grafana/plugins /var/lib/grafana/plugins \
 && mv /grafana/bin/* /bin/ \
 && grafana-cli plugins update-all 

VOLUME  ["/grafana"]

EXPOSE 3000

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/bin/grafana-server", "--homepath", "/grafana"]
