resource "google_pubsub_topic" "leonaro-topic" {
  name = var.pubsub_topic_name

  labels = {
    service = "leonardo"
  }
}

resource "google_pubsub_topic_iam_member" "leonardo_sa_iam" {
  count = "${length(var.pubsub_roles)}"
  topic = "${google_pubsub_topic.leonaro-topic.name}"
  role   = "${element(var.pubsub_roles, count.index)}"
  member = "serviceAccount:${data.google_service_account.config_reader.email}"
}