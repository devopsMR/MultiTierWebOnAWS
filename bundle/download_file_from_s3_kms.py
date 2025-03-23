import boto3
import os

# Set up AWS credentials for the IAM user (without KMS decryption access)
session = boto3.Session(
    aws_access_key_id=  os.getenv("AWS_ACCESS_KEY"),
    aws_secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY")
,
    region_name='eu-central-1'  # Replace with your region if needed
)

# S3 client using the IAM user credentials
s3 = session.client('s3')

# Define bucket and file details
bucket_name = "test-eks-mrosen"
file_name = "tags.xlsx"
download_file_name = "myfile_tags.xlsx"  # File to download locally

# Attempt to download the file
try:
    print(f"Downloading {file_name} from {bucket_name} with IAM user...")
    s3.download_file(bucket_name, file_name, download_file_name)
    print(f"File downloaded successfully as {download_file_name}")
except Exception as e:
    print(f"Error: {e}")