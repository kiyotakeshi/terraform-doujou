# Define the provider
provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}" # AWS Access key
  secret_key = "${var.AWS_SECRET_KEY}" # AWS Secret Access Key
  # shared_credentials_file = "/Users/tf_user/.aws/creds"
  region     = "${var.AWS_REGION}"     # The region in which you want to Operate
}
