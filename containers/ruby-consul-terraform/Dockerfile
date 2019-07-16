FROM broadinstitute/dsde-toolbox:consul-0.20.0
ENV TERRAFORM_VERSION=0.11.13

RUN apk update && \
    apk add curl jq python python-dev libffi-dev openssl-dev bash ca-certificates git openssl unzip wget && \
    pip install pyjwt cryptography && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/tmp/*

ENV PATH = $PATH:/usr/local/google-cloud-sdk/bin/

ENTRYPOINT ["/usr/bin/terraform"]

CMD ["--help"]

VOLUME ["/data"]

WORKDIR /data

RUN mkdir -p /workbench

COPY ./render_configs.rb /workbench/render_configs.rb
COPY ./google_token.sh /workbench/google_token.sh
