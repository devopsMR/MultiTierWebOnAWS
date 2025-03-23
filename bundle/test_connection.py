import boto3
import json
import time
from botocore.exceptions import BotoCoreError, ClientError

# Kinesis configurations
REGION_NAME = 'eu-central-1'
STREAM_NAME = 'dev-data-stream'


def test_connection(kinesis_client, stream_name):
    """
    Test connection to Kinesis Data Stream.
    Verifies if the stream exists and is active, and fetches shard details.
    """
    try:
        print(f"Testing connection to Kinesis stream '{stream_name}' in region '{REGION_NAME}'...")

        # Describe the stream to check its status and get shard info
        response = kinesis_client.describe_stream(StreamName=stream_name)
        stream_status = response['StreamDescription']['StreamStatus']

        if stream_status != 'ACTIVE':
            print(f"Stream '{stream_name}' is not active! Current status: {stream_status}")
            return None

        shards = response['StreamDescription']['Shards']
        if not shards:
            print(f"No shards found in the stream '{stream_name}'.")
            return None

        print(f"Connection successful! Stream '{stream_name}' is active with {len(shards)} shard(s).")

        # Return the first shard ID as an example (multi-shard handling can be added later)
        return shards[0]['ShardId']

    except (BotoCoreError, ClientError) as error:
        print(f"Error connecting to Kinesis stream: {error}")
        return None


def fetch_records_from_stream(kinesis_client, stream_name, shard_id):
    """
    Fetch records from the Kinesis stream using the specified shard ID.
    """
    try:
        # Get an iterator from the shard
        shard_iterator = kinesis_client.get_shard_iterator(
            StreamName=stream_name,
            ShardId=shard_id,
            ShardIteratorType='TRIM_HORIZON'  # Change to 'LATEST' if you want only new data
        )['ShardIterator']

        print(f"Listening for records in shard '{shard_id}' of stream '{stream_name}'...")

        while True:
            # Fetch records
            response = kinesis_client.get_records(ShardIterator=shard_iterator, Limit=10)

            # Process each record
            for record in response['Records']:
                data = record['Data'].decode('utf-8')  # Decode binary data to string
                print(f"Received record: {data}")

            # Get the next shard iterator
            shard_iterator = response['NextShardIterator']

            time.sleep(1)  # Add delay to avoid throttling

    except (BotoCoreError, ClientError) as error:
        print(f"Error fetching records from the stream: {error}")


def send_test_data(kinesis_client, stream_name):
    """
    Send a test record to the Kinesis data stream.
    """
    data = {"message": "This is a nice test record from the test_connection script!", "partition_key": "test123"}
    print(f"Sending test data to stream '{stream_name}'...")

    try:
        response = kinesis_client.put_record(
            StreamName=stream_name,
            Data=json.dumps(data),  # Serialize data as JSON
            PartitionKey="test123"  # Partition key can be any string
        )
        print(f"Test data sent successfully! Response: {response}")
    except (BotoCoreError, ClientError) as error:
        print(f"Error sending test data: {error}")


if __name__ == '__main__':
    # Initialize the Kinesis client
    kinesis_client = boto3.client('kinesis', region_name=REGION_NAME)

    # Step 1: Test connection to the Kinesis stream
    shard_id = test_connection(kinesis_client, STREAM_NAME)
    if not shard_id:
        print("Connection test failed. Exiting...")
        exit(1)

    # Step 2: Send test data to the Kinesis stream
    send_test_data(kinesis_client, STREAM_NAME)

    # Step 3: Fetch records from the Kinesis stream
    fetch_records_from_stream(kinesis_client, STREAM_NAME, shard_id)
