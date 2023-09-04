# JSON-CSV-Lambda-s3-Conversion
This is terraform-based infrastructure as a code where JSON is converted to CSV and displayed in Quicksight

## Architecture
![terraform drawio (1)](https://github.com/NadibHussain/JSON-CSV-Lambda-s3-Conversion/assets/44313607/632421a3-a65d-48a9-9cf3-38cf5a42d29a)


## Features

* Can be used to Change JSON to CSV from S3 and upload back to S3
* Letting user notify by SNS by email that conversion is complete
* Using Manifest.json to configure QuickSight

## Requirements

* Python 2.7 or higher
* AWS SDK
* QuickSight Subscription

## Terraform version compatibility

| Module version | Terraform version |
|----------------|-------------------|
| 1.x.x          | 0.12.x            |
| 0.x.x          | 0.11.x            |

## Usage

To see what will be created before applying
```
terraform plan
```
For creating the infrastructure
```
terraform apply
```
For destroying the infrastructure
```
terraform destroy
```
