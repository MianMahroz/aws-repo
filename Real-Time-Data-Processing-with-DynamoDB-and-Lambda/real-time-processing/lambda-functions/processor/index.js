const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    console.log('Received event:', JSON.stringify(event, null, 2));
    
    for (const record of event.Records) {
        try {
            console.log('Processing record:', JSON.stringify(record, null, 2));
            
            if (record.eventName === 'INSERT') {
                await processInsert(record.dynamodb.NewImage);
            } else if (record.eventName === 'MODIFY') {
                await processModify(record.dynamodb.OldImage, record.dynamodb.NewImage);
            } else if (record.eventName === 'REMOVE') {
                await processRemove(record.dynamodb.OldImage);
            }
        } catch (error) {
            console.error('Error processing record:', error);
            // Continue processing other records even if one fails
        }
    }
    
    return `Successfully processed ${event.Records.length} records.`;
};

async function processInsert(newImage) {
    console.log('Processing INSERT event');
    // Add your business logic for insert events here
    // Example: Transform data and write to another table
}

async function processModify(oldImage, newImage) {
    console.log('Processing MODIFY event');
    // Add your business logic for modify events here
    // Example: Compare old and new values and take action
}

async function processRemove(oldImage) {
    console.log('Processing REMOVE event');
    // Add your business logic for remove events here
    // Example: Archive deleted items
}