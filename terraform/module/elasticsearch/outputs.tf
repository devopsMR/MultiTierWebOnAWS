output "ec2_private_ip" {
  value = aws_instance.ec2.private_ip
}

output "opensearch_endpoint" {
  value = aws_elasticsearch_domain.opensearch.endpoint
}

output "ec2_opensearch_public_ip" {
  value = aws_instance.ec2.public_ip
}
