# s3-cross-account-access-using-lamda-kms

#### Actions on Account A
- Create Custom KMS KEY and add KMS Key policy to allow  iAM role from account B to access KMS key:

       {
              "Sid": "Allow use of the key",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::345657619384:role/s3-cross-account-access-role"
              },
              "Action": [
                  "kms:Encrypt",
                  "kms:Decrypt",
                  "kms:ReEncrypt*",
                  "kms:GenerateDataKey*",
                  "kms:DescribeKey"
              ],
              "Resource": "*"
      }
  
- Create S3 Bucket and ref above generated KMS key
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
      			"Resource": [
      				"arn:aws:s3:::db-asset/*",
      				"arn:aws:s3:::app-asset-kms/*"
      			]
      		},
      		{
      			"Effect": "Allow",
      			"Action": [
      				"kms:Encrypt",
      				"kms:Decrypt",
      				"kms:DescribeKey",
      				"kms:GenerateDataKey*"
      			],
      			"Resource": "arn:aws:kms:eu-north-1:905418379086:key/c8720f68-6a79-4694-b8b9-ebcc0ac4c0aa"
      		}
      	]
      }


#### LAMBDA FUNCTION (Assign above role to lambda function)

      import json
      import boto3

      client = boto3.client('s3')
  
      def lambda_handler(event, context):    
          
          object = client.get_object(Bucket="app-asset-kms", Key="coffee.jpg")
          result = object['Body']
          
          print("S3 object: ",result)
          
          return {
              'statusCode': 200,
              'body': json.dumps("file retrived successfully")
          }


  
