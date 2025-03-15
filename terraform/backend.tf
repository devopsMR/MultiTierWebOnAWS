terraform {
  backend "s3" {
    bucket         = "multi-tier-web-app-aws"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = false
    dynamodb_table = "terraform-locking-development"
  }
}



# first must crate the Backend Bucket Manually since Terraform can’t function without a s3 backend during `terraform init`
# aws s3api create-bucket \
#   --bucket multi-tier-web-app-aws \
#   --region eu-central-1
# must create dynamodb Manually
# aws dynamodb create-table \
#    --table-name "multi-tier-web-app-aws-terraform-locking-dev" \
#    --attribute-definitions AttributeName=LockID,AttributeType=S \
#    --key-schema AttributeName=LockID,KeyType=HASH \
#    --billing-mode PAY_PER_REQUEST \
#    --tags Key=Environment,Value=development Key=Purpose,Value="Terraform Locking" \
#    --region "eu-central-1"