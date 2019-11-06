ui:
  image: gcr.io/broad-dsp-gcr-public/firecloud-ui:${image}
  log_driver: "syslog"
  log_opt:
    tag: "firecloud-ui"
  ports:
    - "80:80"
    - "443:443"
    - "127.0.0.1:8888:8888"
  volumes:
    - ./ca-bundle.crt:/etc/ssl/certs/ca-bundle.crt
    - ./server.crt:/etc/ssl/certs/server.crt
    - ./server.key:/etc/ssl/private/server.key
    - .:/config:ro
  environment:
    LOG_LEVEL: warn
    SERVER_NAME: ${fc_ui_hostname}
    ENABLE_STACKDRIVER: 'yes'
  restart: always
