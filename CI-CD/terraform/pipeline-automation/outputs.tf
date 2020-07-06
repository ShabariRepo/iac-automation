output "Jenkins_DNS" {
  value = "https://${aws_route53_record.jenkins_master.name}"
}

output "Nexus_DNS" {
  value = "https://${aws_route53_record.nexus.name}"
}

output "Registry_DNS" {
  value = "https://${aws_route53_record.registry.name}"
}

output "Jenkins_SG_ID" {
  value = "${aws_security_group.jenkins_master_sg.id}"
}
