FROM alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories

RUN apk --update upgrade && \
    apk add --update inotify-tools bash docker-cli && \
    rm -rf /var/cache/apk/*


ENV wd /workdir
RUN mkdir -p ${wd}
WORKDIR ${wd}
COPY docker-workdir/* ./
RUN chmod +x *.sh

ENV NGINXNAMEFILTER=nginx
ENV WATCHVOLUME=/etc/nginx

VOLUME ["/etc/nginx"]

ENTRYPOINT [ "./entrypoint.sh" ]
