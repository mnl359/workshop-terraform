# List of AWS Policies to run the project

To be able to test this project in your AWS account you must need to create an IAM Account, it could has Full Access or you could use this policies and assign them to a custom IAM role. In the following list of files you can find all the policies:

- circleci_dynamodb.txt
- circleci_ec2.txt
- circleci_elb.txt
- circleci_rds.txt
- circleci_s3.txt

You must adjust the DynamoDB table name in the circleci_dynamodb.txt file and the S3 bucket name in the circleci_s3.txt file.