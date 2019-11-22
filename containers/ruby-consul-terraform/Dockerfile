FROM alpine:edge

ENV ALPINE_VERSION=edge \
  TERRAFORM_VERSION=0.12.7 \
  CONSUL_TEMPLATE_VERSION=0.20.0 \
  NODEJS_VERSION=12.13.1-r0

RUN apk update

RUN apk add \
  curl \
  jq \
  python \
  bash \
  ca-certificates \
  git \
  openssl \
  zip \
  unzip \
  wget \
  openjdk8-jre

# Ruby, for rendering service configs
RUN apk add ruby \
  ruby-dev \
  alpine-sdk
RUN gem install json && \
  gem install rubysl-open3

# Node, for building Terra UI
RUN apk add \
  --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/main/ \
  nodejs=${NODEJS_VERSION}
RUN apk add \
  --no-cache \
  --repository http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/main/ \
  npm=${NODEJS_VERSION}

# Terraform for terraforming
RUN cd /tmp && \
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

# Consul-template for rendering service configs
RUN cd /tmp && \
  wget \
  --no-check-certificate \
  https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  -O /tmp/consul_template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
  unzip consul_template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
  mv consul-template /usr/local/bin/
COPY consul_template_config.hcl /etc/consul-template/config/config.json

# Google cloud for Terraform
RUN cd /tmp && \
  wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip -O /tmp/google-cloud-sdk.zip && \
  cd /usr/local && unzip /tmp/google-cloud-sdk.zip && \
  google-cloud-sdk/install.sh --usage-reporting=false --path-update=true --bash-completion=true && \
  google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Cleanup
RUN rm -rf /tmp/* && \
  rm -rf /var/cache/apk/* && \
  rm -rf /var/tmp/*

ENV PATH = $PATH:/usr/local/google-cloud-sdk/bin/

ENTRYPOINT ["/usr/bin/terraform"]

CMD ["--help"]

VOLUME ["/data"]

WORKDIR /data

RUN mkdir -p /workbench

COPY ./render_configs.rb /workbench/render_configs.rb
