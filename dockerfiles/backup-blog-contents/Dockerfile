FROM centos:7
LABEL maintainer="nasa9084"

COPY ./google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
RUN yum update -y && yum install -y \
        google-cloud-sdk \
        mysql \
        wget \
        which \
        && rm -rf /var/cache/yum/* \
        && yum clean all
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/bin/kubectl
RUN wget -O /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    && chmod +x /usr/bin/jq


COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
