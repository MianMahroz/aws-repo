# s3-cross-account-access-using-lamda

#### Actions on Account A
- Create S3 Bucket
- Add role arn from the account B in S3 policy resource.
    
      {
        "Version": "2012-10-17",
        "Id": "Policy1716203482211",
        "Statement": [
            {
                "Sid": "Stmt1716203459651",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::345657619384:role/s3-cross-account-access-role"
                },
                "Action": [
                    "s3:GetObject",
                    "s3:GetObjectAttributes",
                    "s3:GetObjectTagging",
                    "s3:GetObjectVersion"
                ],
                "Resource": "arn:aws:s3:::db-asset/*"
            }
        ]
      }

    


#### Actions on Account B
- Create a lambda function to access the S3 object
- Create a role without adding any AWS-managed policy. Once the role is created add permissions using the editor as below:
    
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Sid": "VisualEditor0",
                  "Effect": "Allow",
                  "Action": "s3:GetObject",
                  "Resource": "arn:aws:s3:::db-asset/*"
              }
          ]
      }


  ### LAMBDA FUNCTION

      import json
      import boto3
      
      def lambda_handler(event, context):        
          client = boto3.client('s3')
          object = client.get_object(Bucket="db-asset", Key="coffee.jpg")
          result = object['Body']
          
          
          return {
              'statusCode': 200,
              'body': json.dumps(result)
          }
  






