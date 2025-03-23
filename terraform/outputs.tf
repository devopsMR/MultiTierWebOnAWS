output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "ec2_public_ips" {
  value = module.asg.ec2_public_ips
}

output "rds_endpoint" {
  description = "RDS MySQL Instance Endpoint"
  value       = module.rds.rds_endpoint
}

output "opensearch_endpoint" {
  value = module.elastic-search.opensearch_endpoint
}

output "ec2_opensearch_public_ip" {
  value = module.elastic-search.ec2_opensearch_public_ip
}
# output "kms_key_arn" {
#   description = "The ARN of the created KMS key"
#   value       = aws_kms_key.example_kms_key.arn
# }
#
# output "s3_bucket_name" {
#   description = "The name of the S3 bucket created"
#   value       = aws_s3_bucket.example_bucket.id
# }
