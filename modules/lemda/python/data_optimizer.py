import json
import csv
import boto3
import os
import datetime as dt

s3 = boto3.client('s3')

def lambda_handler(event, context):
    
    datestamp = dt.datetime.now().strftime("%Y/%m/%d")
    timestamp = dt.datetime.now().strftime("%s")
    
    filename_csv = "/tmp/file_{ts}.csv".format(ts=timestamp)
    keyname_s3 = "uploads/quicksight.json".format(ds=datestamp, ts=timestamp)
    
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        key_name = record['s3']['object']['key']
        
    s3_object = s3.get_object(Bucket=bucket_name, Key=key_name)
    data = s3_object['Body'].read()
    contents = data.decode('utf-8')
    
    data = json.load(contents)
    data_file = open(filename_csv, 'w')
    csv_writer = csv.writer(data_file)
    count = 0
    for row in data:
        if count == 0:
    
            # Writing headers of CSV file
            header = row.keys()
            csv_writer.writerow(header)
            count += 1
 
        # Writing data of CSV file
        csv_writer.writerow(row.values())
 
    data_file.close()
    
    with open(filename_csv, 'r') as csv_file_contents:
        response = s3.put_object(Bucket=bucket_name, Key=keyname_s3, Body=csv_file_contents.read())

    os.remove(filename_csv)

    return {
        'statusCode': 200,
        'body': json.dumps('CSV converted to JSON and available at: {bucket}/{key}'.format(bucket=bucket_name,key=keyname_s3))
    }