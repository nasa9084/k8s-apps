FROM busybox:latest
LABEL maintainer = nasa9084 <nasa.9084.bassclarinet@gmail.com>

RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 -O confd &&\
    chmod +x confd &&\
    mv confd /bin/confd

ENTRYPOINT ["confd"]
