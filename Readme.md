LINKS and docs

###Github Repository Link
-[webserver and terraform script](https://github.com/rajvardhanshinde/natwest-intern.git)

###Buket name
-[bucket-name]-natwest-unique-static-website

-[execute shell command for jenkins pipeline] - cd $WORKSPACE
python3 web_server_script.py natwest-unique-static-website


-[Cost Analysis for the AWS Setup in Task 1]-
1. S3 Bucket for Static Website Hosting
Usage: Publicly accessible bucket for static website hosting.

Cost Components:

Storage: $0.023/GB/month (Standard storage)
Data Transfer Out: $0.09/GB (First 1GB/month is free)
Assumptions:
Website size: 10 GB
Monthly Data Transfer Out: 50 GB
Annual Cost for S3:
Storage: 10 GB × $0.023/GB/month × 12 months = $2.76
Data Transfer: 50 GB × $0.09/GB × 12 months = $54.00
Total S3 Cost: $56.76/year

2. EC2 Instance
Usage: Amazon Linux EC2 instance for hosting the web server.
Instance Type: t2.micro (Free Tier eligible for 12 months, then $0.0116/hour).
Cost Components:
Compue: $0.0116/hour
Elastic IP (if required): $0.005/hour when not associated with a running instance
Assumptions:
Instance is running 24/7.
Free Tier has expired.
Annual Cost for EC2:
Compute: $0.0116/hour × 24 hours/day × 365 days = $101.57
Total EC2 Cost: $101.57/year

3. AWS Lambda Function
Usage: Triggered on S3 bucket object creation.
Cost Components:
Free Tier: 1 million requests/month and 400,000 GB-seconds compute time/month are free.
After Free Tier:
$0.20 per 1 million requests
$0.00001667 per GB-second compute time
Assumptions:
10,000 events/month
Execution time per event: 100 ms
Memory allocated: 128 MB
Annual Cost for Lambda:
Requests: (10,000 events/month ÷ 1,000,000) × 12 months × $0.20/million requests = $0.024
Compute: (128 MB ÷ 1024) × 0.1 seconds × 10,000 events/month × 12 months × $0.00001667/GB-second = $0.25
Total Lambda Cost: $0.27/year

4. CloudWatch Logs
Cost Components:
Ingestion: $0.50/GB
Storage: $0.03/GB/month
Assumptions:
1 GB log ingestion/month
12 months log storage
Annual Cost for CloudWatch Logs:
Ingestion: 1 GB/month × $0.50/GB × 12 months = $6.00
Storage: 1 GB × $0.03/GB/month × 12 months = $0.36
Total CloudWatch Cost: $6.36/year

Service	Cost (USD)
S3	$56.76
EC2	$101.57
Lambda	$0.27
CloudWatch Logs	$6.36
Total	$164.96
