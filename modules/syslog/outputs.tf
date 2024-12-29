output "syslog_server_ip" {
  value = aws_instance.syslog_server.private_ip
}