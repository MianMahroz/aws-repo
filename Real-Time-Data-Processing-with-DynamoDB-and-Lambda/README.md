### RUN INSTRUCTIONS

-  terraform init
-  terraform plan
-  terraform apply
-  terraform destroy
  
#### PRE-REQUISITE 
-  cd lambda-functions/processor 
-  npm install    // this will create node modules and package them with lambda 

#### Component Details
1. DynamoDB Table (RealTimeDataTable)
   Purpose: Primary data store with real-time change capture.

#### Key Features:

- Streams Enabled: Captures INSERT/UPDATE/DELETE events.

- TTL (Time-to-Live): Automatically expires old items.

#### Schema:

- Partition Key: id (String)

- Sort Key: timestamp (Number)

#### Capacity Mode: Pay-per-request (auto-scaling).

2. Lambda Function (DataProcessor)
   Purpose: Processes DynamoDB stream events in real-time.

#### Configuration:

- Runtime: Node.js 18.x.

- Memory: 256MB.

- Timeout: 30 seconds.

- Permissions: IAM role with DynamoDB + Stream access.

#### Event Handlers:


- if (record.eventName === 'INSERT') { /* Process new data */ }
- if (record.eventName === 'MODIFY') { /* Handle updates */ }
- if (record.eventName === 'REMOVE') { /* Handle deletes */ }
3. DynamoDB Stream
   View Type: NEW_AND_OLD_IMAGES (sends full before/after data).

- Trigger: Automatically invokes Lambda on data changes.

- Batch Size: 100 records per invocation (configurable).

4. IAM Role (lambda-dynamodb-role)
   Permissions:

- DynamoDB Table Access: PutItem, GetItem, Query, etc.

- Stream Access: GetRecords, GetShardIterator, DescribeStream.

- CloudWatch Logs: CreateLogGroup, PutLogEvents.

5. CloudWatch
   Logs: Stores Lambda execution logs (for debugging).

- Metrics: Tracks invocations, errors, and latency.

#### Data Flow
    Step 1: Client writes data to DynamoDB (e.g., PutItem).
    
    Step 2: DynamoDB stream captures the change.
    
    Step 3: Stream triggers Lambda with the event payload.
    
    Step 4: Lambda processes the event (e.g., transforms data, sends alerts).
    
    Step 5: Logs are sent to CloudWatch.

    Terraform Module Structure
    modules/
    ├── dynamodb/            # Table + stream configuration
    ├── lambda/              # Lambda function + deployment
    ├── iam/                 # IAM role + policies
    └── event-mapping/       # DynamoDB → Lambda trigger
    Why This Architecture?
    Real-Time Processing: Instant reaction to data changes.

Serverless: No servers to manage (auto-scaling).

Cost-Effective: Pay only for actual usage.

Extensible: Add more Lambda functions for complex workflows.

    Sample Use Cases
    User Activity Tracking: Process clickstream data in real-time.
    
    IoT Data Pipeline: Handle sensor data with TTL for automatic cleanup.
    
    E-Commerce: Update recommendations on cart changes.