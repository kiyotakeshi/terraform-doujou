#----------------------
# Project wide variable
variable "PROJECT_NAME" {
  description = "Doujou automation"
}

# variable "PLATFORM" {}

#----------------------
# Varibles for the Providers
variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}

#----------------------
# RDS variables

variable "DB_INSTANCE_CLASS" {}
variable "RDS_ENGINE" {}
variable "ENGINE_VERSION" {}
variable "BACKUP_RETENTION_PERIOD" {}
variable "PUBLICLY_ACCESSIBLE" {}
variable "RDS_USERNAME" {}
variable "RDS_PASSWORD" {}
variable "RDS_ALLOCATED_STORAGE" {}

#----------------------
# Ec2
variable "SSH_CIDR_WEB_SERVER" {}

variable "WEB_SERVER_INSTANCE_TYPE" {}

# windows 以外で使う
# variable "USER_DATA_FOR_WEBSERVER" {}

variable "PEM_FILE_WEBSERVERS" {}

# variable "UNIX_PATH" {}
# variable "WIN_PATH" {}

#----------------------
# VPC Variables
variable "VPC_CIDR_BLOCK" {}

variable "VPC_PUBLIC_SUBNET1_CIDR_BLOCK" {}
variable "VPC_PUBLIC_SUBNET2_CIDR_BLOCK" {}
variable "VPC_PRIVATE_SUBNET1_CIDR_BLOCK" {}
variable "VPC_PRIVATE_SUBNET2_CIDR_BLOCK" {}

#----------------------
# coudwatch alerm


# variable "CLOUD_WATCH_ALERM_ACTION_SNS" {}

