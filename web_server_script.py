import sys
import boto3

def list_buckets():
    s3 = boto3.client('s3')
    try:
        response = s3.list_buckets()
        print("Buckets in your AWS account:")
        for bucket in response['Buckets']:
            print(f"- {bucket['Name']}")
    except Exception as e:
        print(f"Error listing buckets: {e}")

def count_objects(bucket_name):
    s3 = boto3.client('s3')
    paginator = s3.get_paginator('list_objects_v2')
    total_objects = 0
    try:
        for page in paginator.paginate(Bucket=bucket_name):
            if 'Contents' in page:
                total_objects += len(page['Contents'])
        print(f"Total number of objects in bucket '{bucket_name}': {total_objects}")
    except Exception as e:
        print(f"Error counting objects in bucket '{bucket_name}': {e}")

if __name__ == "__main__":
    print("Listing all buckets:")
    list_buckets()
    
    # Check if a bucket name argument is passed
    if len(sys.argv) < 2:
        print("Error: Please provide the bucket name as a command-line argument.")
        sys.exit(1)
    
    # Get the bucket name from the command line argument
    bucket_name = sys.argv[1]
    
    print("\nCounting objects in the specified bucket:")
    count_objects(bucket_name)
