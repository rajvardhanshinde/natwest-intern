import boto3

def list_buckets():
   
    s3 = boto3.client('s3', region_name='ap-south-1')  
    try:
        response = s3.list_buckets()
        print("Buckets in your AWS account:")
        for bucket in response['Buckets']:
            print(f"- {bucket['Name']}")
    except Exception as e:
        print(f"Error listing buckets: {e}")

def count_objects(bucket_name):
    
    s3 = boto3.client('s3', region_name='ap-south-1')
    try:
        paginator = s3.get_paginator('list_objects_v2')
        total_objects = 0
        for page in paginator.paginate(Bucket=bucket_name):
            if 'Contents' in page:
                total_objects += len(page['Contents'])
        print(f"Total number of objects in bucket '{bucket_name}': {total_objects}")
    except Exception as e:
        print(f"Error counting objects in bucket '{bucket_name}': {e}")

if __name__ == "__main__":
    print("Listing all buckets:")
    list_buckets()
    print("\nCounting objects in a specific bucket:")
    bucket_name = input("Enter the bucket name: ")
    count_objects(bucket_name)
