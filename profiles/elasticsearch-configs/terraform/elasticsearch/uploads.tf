resource "google_storage_bucket_object" "docker-compose" {
  count = "${length(data.google_compute_instance_group.service-instances.instances)}"
  name   = "${element(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index)), length(split("/", element(data.google_compute_instance_group.service-instances.instances, count.index))) - 1)}/configs/docker-compose.yaml"
  content = <<EOT
version: '2'
services:
  elasticsearch:
    image: broadinstitute/elasticsearch:5.4.0_6
    cap_add:
      - IPC_LOCK
    ports:
      - "9200:9200"
      - "9300:9300"
    volumes:
      - /app/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
      - /app/logging.yml:/usr/share/elasticsearch/config/logging.yml
    env_file:
      - /app/elasticsearch.env
    environment:
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - "TYPE=MASTER"
      - "UNICAST_HOSTS=master"
      - "MIN_MASTERS=1"
    ulimits:
      memlock: -1
    mem_limit: 2g
    memswap_limit: 2g
    restart: always
EOT
  bucket = "${var.config_bucket_name}"
}

resource "google_storage_bucket_object" "elasticsearch-yml" {
  count = "${length(data.google_compute_instance.instances.*.name)}"
  name   = "${element(data.google_compute_instance.instances.*.name, count.index)}/configs/elasticsearch.yml"
  content = <<EOT
bootstrap:
  memory_lock: true
cluster:
  name: elasticsearch5a
network:
  bind_host: _eth0_
  publish_host: ${element(data.google_compute_instance.instances.*.name, count.index)}
  host: ${element(data.google_compute_instance.instances.*.name, count.index)}
http:
  cors:
    allow-origin: '*'
    enabled: true
node:
  name: elasticsearch5a1
xpack:
  security:
    enabled: false
  graph:
    enabled: false
  ml:
    enabled: false
  monitoring:
    enabled: false
  watcher:
    enabled: false
EOT
  bucket = "${var.config_bucket_name}"
}

resource "google_storage_bucket_object" "logging-yml" {
  count = "${length(data.google_compute_instance.instances.*.name)}"
  name   = "${element(data.google_compute_instance.instances.*.name, count.index)}/configs/logging.yml"
  content = <<EOT
# you can override this using by setting a system property, for example -Des.logger.level=DEBUG
es.logger.level: INFO
rootLogger: INFO, console
logger:
  # log action execution errors for easier debugging
  action: DEBUG
  # reduce the logging for aws, too much is logged under the default INFO
  com.amazonaws: WARN
  index.indexing.slowlog: TRACE
  index.search.slowlog: TRACE

appender:
  console:
    type: console
    layout:
      type: consolePattern
      conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"
EOT
  bucket = "${var.config_bucket_name}"
}

resource "google_storage_bucket_object" "elasticsearch-env" {
  count = "${length(data.google_compute_instance.instances.*.name)}"
  name   = "${element(data.google_compute_instance.instances.*.name, count.index)}/configs/elasticsearch.env"
  content = <<EOT
INSTANCE=${element(data.google_compute_instance.instances.*.name, count.index)}
INSTANCE_PRIV=${element(data.google_compute_instance.instances.*.name, count.index)}
ES_JAVA_OPTS=-Xms3500m -Xmx3500m
EOT
  bucket = "${var.config_bucket_name}"
}
