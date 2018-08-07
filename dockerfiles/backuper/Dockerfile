FROM alpine:3.8
LABEL maintainer="nasa9084 <nasa.9084.bassclarinet@gmail.com>"

COPY entrypoint.sh /entrypoint.sh

RUN wget https://dl.minio.io/client/mc/release/linux-amd64/mc &&\
    chmod +x mc &&\
    mv mc /usr/local/bin/mc

CMD ["sh", "-xe", "/entrypoint.sh"]
