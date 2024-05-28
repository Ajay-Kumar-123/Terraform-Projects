resource "aws_s3_bucket" "remote-s3" {
  bucket = "remote-backend-infra"
}

resource "aws_dynamodb_table" "state_lock-db" {
  name = "tf-state-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}