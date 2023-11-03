resource "shoreline_notebook" "rabbitmq_node_performance_degradation_incident" {
  name       = "rabbitmq_node_performance_degradation_incident"
  data       = file("${path.module}/data/rabbitmq_node_performance_degradation_incident.json")
  depends_on = [shoreline_action.invoke_rabbitmq_update_node]
}

resource "shoreline_file" "rabbitmq_update_node" {
  name             = "rabbitmq_update_node"
  input_file       = "${path.module}/data/rabbitmq_update_node.sh"
  md5              = filemd5("${path.module}/data/rabbitmq_update_node.sh")
  description      = "Increase the resources allocated to the RabbitMQ node(s) affected by the incident, such as CPU, RAM, or disk space, to improve its performance."
  destination_path = "/tmp/rabbitmq_update_node.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_rabbitmq_update_node" {
  name        = "invoke_rabbitmq_update_node"
  description = "Increase the resources allocated to the RabbitMQ node(s) affected by the incident, such as CPU, RAM, or disk space, to improve its performance."
  command     = "`chmod +x /tmp/rabbitmq_update_node.sh && /tmp/rabbitmq_update_node.sh`"
  params      = ["RAM_ALLOCATION","DISK_SPACE_ALLOCATION","NODE_NAME","CPU_ALLOCATION"]
  file_deps   = ["rabbitmq_update_node"]
  enabled     = true
  depends_on  = [shoreline_file.rabbitmq_update_node]
}

