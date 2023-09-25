output "msk_zookeeper_connect_string" {
  value = "${module.msk.zookeeper_connect_string}"
}

output "msk_bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = "${module.msk.bootstrap_brokers_tls}"
}